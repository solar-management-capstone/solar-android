import 'package:cloud_firestore/cloud_firestore.dart';

class MessageFirebase {
  String? userIdSent;
  String? username;
  String? phone;
  String? email;
  Timestamp? createdAt;
  String? content;

  MessageFirebase({
    this.userIdSent,
    this.username,
    this.phone,
    this.email,
    this.createdAt,
    this.content,
  });

  MessageFirebase.fromJson(Map<String, dynamic> json) {
    userIdSent = json['userIdSent'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userIdSent'] = userIdSent;
    data['username'] = username;
    data['phone'] = phone;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['content'] = content;
    data['phone'] = phone;
    return data;
  }
}

class MessageNotificationFirebase {
  String? userIdSent;
  String? username;
  String? phone;
  String? email;
  Timestamp? createdAt;
  String? content;
  bool? seen;

  MessageNotificationFirebase({
    this.userIdSent,
    this.username,
    this.phone,
    this.email,
    this.createdAt,
    this.content,
    this.seen,
  });

  MessageNotificationFirebase.fromJson(Map<String, dynamic> json) {
    userIdSent = json['userIdSent'];
    username = json['username'];
    phone = json['phone'];
    email = json['email'];
    createdAt = json['createdAt'];
    content = json['content'];
    seen = json['seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userIdSent'] = userIdSent;
    data['username'] = username;
    data['phone'] = phone;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['content'] = content;
    data['phone'] = phone;
    data['seen'] = seen;
    return data;
  }
}
