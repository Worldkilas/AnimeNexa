import 'package:anime_nexa/features/messaging/models/message.dart';

abstract class IMessageRepository {
  Future<void> sendMessage(Message message, String chatId);
  Stream<List<Message>> getMessages(String chatId,
      {int limit = 20, String? lastMessageId});
  Future<void> deleteMessage(String messageId, String chatId);
}
//fa
