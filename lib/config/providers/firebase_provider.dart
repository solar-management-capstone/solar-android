import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/models/message_firebase.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';

class FirebaseProvider extends ChangeNotifier {
  List<MessageFirebase> messages = [];

  List<MessageFirebase> getMessage() {
    final userId = SharedPreferencesUtils.getId();
    FirebaseFirestore.instance
        .collection('messages')
        .doc(userId)
        .collection('with-user')
        .doc('1')
        .collection('messages')
        .orderBy('createdAt')
        .snapshots(includeMetadataChanges: true)
        .listen((messageFirebase) {
      messages = messageFirebase.docs
          .map(
            (doc) => MessageFirebase.fromJson(
              doc.data(),
            ),
          )
          .toList();
      notifyListeners();
    });
    return messages;
  }
}
