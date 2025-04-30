import 'package:anime_nexa/models/chat.dart';
import 'package:anime_nexa/models/message.dart';

abstract class IMessageRepository {
  Future<void> sendMessage(
    Message message,
    Chat chat, {
    String? replyToMessageId,
  });
  Stream<List<Message>> getMessages(String conversationId,
      {int limit = 20, String? lastMessageId});
  Future<void> deleteMessage(String messageId, Chat chat);
}
