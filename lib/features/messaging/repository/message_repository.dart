import 'package:anime_nexa/features/messaging/repository/i_chat_repo.dart';
import 'package:anime_nexa/features/messaging/repository/i_message_repository.dart';
import 'package:anime_nexa/features/messaging/models/chat.dart';
import 'package:anime_nexa/features/messaging/models/message.dart';
import 'package:anime_nexa/shared/constants/collections_paths.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository implements IMessageRepository, IChatRepository {
  final FirebaseFirestore _firestore;

  MessageRepository(this._firestore);

  @override
  Future<void> sendMessage(Message message, String chatId) async {
    try {
      if (chatId.isEmpty) {
        final newChat = Chat(
            id: _firestore.collection(CollectionsPaths.chats).doc().id,
            isGroup: false,
            members: [message.senderId!, message.receiverId!]);
        chatId = (await createChat(newChat)).id;
      }

      final messageId = message.id ??
          _firestore
              .collection(CollectionsPaths.chats)
              .doc(chatId)
              .collection(CollectionsPaths.messages)
              .doc()
              .id;
      message = message.copyWith(id: messageId, timeSent: DateTime.now());

      await _firestore.runTransaction((transaction) async {
        transaction.set(
          _firestore
              .collection(CollectionsPaths.chats)
              .doc(chatId)
              .collection(CollectionsPaths.messages)
              .doc(messageId),
          message.toJson(),
        );

        transaction.update(
          _firestore.collection(CollectionsPaths.chats).doc(chatId),
          {
            'lastMessage': message.message,
            'lastMessageTimestamp': message.timeSent,
          },
        );
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId, String chatId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        transaction.delete(
          _firestore
              .collection(CollectionsPaths.chats)
              .doc(chatId)
              .collection(CollectionsPaths.messages)
              .doc(messageId),
        );

        final chatRef =
            _firestore.collection(CollectionsPaths.chats).doc(chatId);
        final chatSnapshot = await transaction.get(chatRef);

        if (chatSnapshot.exists &&
            chatSnapshot.data()?['lastMessageTimestamp'] != null &&
            chatSnapshot.data()?['lastMessage'] != null) {
          final messagesQuery = await _firestore
              .collection(CollectionsPaths.chats)
              .doc(chatId)
              .collection(CollectionsPaths.messages)
              .orderBy('timeSent', descending: true)
              .limit(1)
              .get();

          if (messagesQuery.docs.isNotEmpty) {
            final newLastMessage =
                Message.fromJson(messagesQuery.docs.first.data());
            transaction.update(chatRef, {
              'lastMessage': newLastMessage.message,
              'lastMessageTimestamp': newLastMessage.timeSent,
            });
          } else {
            transaction.update(chatRef, {
              'lastMessage': null,
              'lastMessageTimestamp': null,
            });
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  @override
  Stream<List<Message>> getMessages(String chatId,
      {int limit = 20, String? lastMessageId}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(CollectionsPaths.chats)
        .doc(chatId)
        .collection(CollectionsPaths.messages)
        .orderBy('timeSent', descending: true)
        .limit(limit);

    if (lastMessageId != null) {
      query = query.startAfter([
        _firestore
            .collection(CollectionsPaths.chats)
            .doc(chatId)
            .collection(CollectionsPaths.messages)
            .doc(lastMessageId)
            .get()
            .then((doc) => doc['timeSent']),
      ]);
    }

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

  Future<void> markMessageAsRead(String messageId, String chatId) async {
    try {
      await _firestore
          .collection(CollectionsPaths.chats)
          .doc(chatId)
          .collection(CollectionsPaths.messages)
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
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
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList());
  }

  @override
  Future<void> addParticipant(String chatId, String uid) async {
    await _firestore.collection(CollectionsPaths.chats).doc(chatId).update({
      'members': FieldValue.arrayUnion([uid]),
    });
  }

  @override
  Future<void> removeParticipant(String chatId, String uid) async {
    await _firestore.collection(CollectionsPaths.chats).doc(chatId).update({
      'members': FieldValue.arrayRemove([uid]),
    });
  }

  @override
  Future<void> updateChat(Chat chat) async {
    await _firestore
        .collection(CollectionsPaths.chats)
        .doc(chat.id)
        .update(chat.toJson());
  }
}
