import 'package:anime_nexa/features/messaging/models/chat.dart';

abstract class IChatRepository {
  Future<Chat> createChat(Chat chat);
  Future<void> updateChat(Chat chat);
  Stream<List<Chat>> getChats(String uid);
  Future<void> addParticipant(String chatID, String uid);
  Future<void> removeParticipant(String chatID, String uid);
}
