import 'package:anime_nexa/features/messaging/repository/i_chat_repo.dart';
import 'package:anime_nexa/features/messaging/repository/i_message_repository.dart';
import 'package:anime_nexa/models/chat.dart';
import 'package:anime_nexa/models/message.dart';
import 'package:anime_nexa/shared/constants/collections_paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository implements IMessageRepository, IChatRepository {
  final FirebaseFirestore _firestore;

  MessageRepository(this._firestore);

  @override
  Future<void> sendMessage(Message message, Chat chat,
      {String? replyToMessageId}) async {
    try {
      if (message.chatID == null) {
        final newChat = await createChat(chat);
        message = message.copyWith(chatID: newChat.id);
      }
      await _firestore.runTransaction((transaction) async {
        transaction.set(
          _firestore.collection(CollectionsPaths.messages).doc(message.id),
          message.toJson(),
        );
        transaction.update(
          _firestore.collection(CollectionsPaths.chats).doc(message.chatID),
          {
            'lastMessage': message.id,
            'lastMessageTimestamp': message.timeSent,
          },
        );
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId, Chat chat) async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Delete the message
        transaction.delete(
          _firestore.collection(CollectionsPaths.messages).doc(messageId),
        );

        // Check if the deleted message was the latest
        final chatRef =
            _firestore.collection(CollectionsPaths.chats).doc(chat.id);
        final chatSnapshot = await transaction.get(chatRef);
        if (chatSnapshot.exists &&
            chatSnapshot.data()!['lastMessage'] == messageId) {
          // Find the next-latest message
          final nextMessageSnapshot = await _firestore
              .collection(CollectionsPaths.messages)
              .where('chatID', isEqualTo: chat.id)
              .orderBy('timeSent', descending: true)
              .limit(1)
              .get();
          final nextMessage = nextMessageSnapshot.docs.isNotEmpty
              ? nextMessageSnapshot.docs.first.data()
              : null;
          transaction.update(chatRef, {
            'lastMessage': nextMessage != null ? nextMessage['id'] : null,
            'lastMessageTimestamp':
                nextMessage != null ? nextMessage['timeSent'] : null,
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatID,
      {int limit = 20, String? lastMessageId}) {
    return _firestore
        .collection(CollectionsPaths.messages)
        .where('chatID', isEqualTo: chatID)
        .orderBy('timeSent', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
    });
  }

  // @override
  // Future<void> markMessageAsRead(String messageId, String userId) {
  //   return _firestore
  //       .collection(CollectionsPaths.messages)
  //       .doc(messageId)
  //       .update({
  //     'isRead': true,
  //   });
  // }

  @override
  Future<void> addParticipant(String chatID, String uid) async {
    await _firestore.collection(CollectionsPaths.chats).doc(chatID).update({
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<Chat> createChat(Chat chat) async {
    await _firestore
        .collection(CollectionsPaths.chats)
        .doc(chat.id)
        .set(chat.toJson());
    return chat;
  }

  @override
  Stream<List<Chat>> getChats(String uid) {
    return _firestore
        .collection(CollectionsPaths.chats)
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Chat.fromJson(doc.data())).toList());
  }

  @override
  Future<void> removeParticipant(String chatID, String uid) async {
    await _firestore.collection(CollectionsPaths.chats).doc(chatID).update({
      'members': FieldValue.arrayRemove([uid])
    });
  }

  @override
  Future<void> updateChat(Chat chat) async {
    await _firestore
        .collection(CollectionsPaths.chats)
        .doc(chat.id)
        .set(chat.toJson());
  }
}
