import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_solar_mp/models/message_firebase.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class ChatService {
  static final fireStore = FirebaseFirestore.instance;

  Future<void> addMessage({required message}) async {
    final userId = SharedPreferencesUtils.getId();

    MessageFirebase messageFirebase = MessageFirebase(
      userIdSent: userId,
      content: message,
      createdAt: Timestamp.now(),
      email: null,
      phone: SharedPreferencesUtils.getPhoneNumber(),
      username: SharedPreferencesUtils.getPhoneNumber(),
    );

    await fireStore
        .collection('messages')
        .doc(userId)
        .collection('with-user')
        .doc('1')
        .collection('messages')
        .add(messageFirebase.toJson());

    await fireStore
        .collection('messages')
        .doc('1')
        .collection('with-user')
        .doc(userId)
        .collection('messages')
        .add(messageFirebase.toJson());

    MessageNotificationFirebase messageNotificationFirebase =
        MessageNotificationFirebase(
            userIdSent: userId,
            content: message,
            createdAt: Timestamp.now(),
            email: null,
            phone: SharedPreferencesUtils.getPhoneNumber(),
            username: SharedPreferencesUtils.getPhoneNumber(),
            seen: false);

    await fireStore
        .collection('messages-notification')
        .doc('1')
        .collection('newest-message')
        .doc(userId)
        .set(messageNotificationFirebase.toJson());
  }
}
