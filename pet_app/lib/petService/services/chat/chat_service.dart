import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/petService/model/chat_message.dart';
import 'package:pet_app/petService/model/user.dart';

abstract class ChatService {
  void sendMessage(String toUid, String message);

  Stream<QuerySnapshot> getChatStream(String uid);

  Future<List<User>> getChattedUsers();
  Future<ChatMessage> getFirstMessage(String recipientUid);
}
