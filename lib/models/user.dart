import 'dart:convert';

class User {
  final String? accountId;
  final String? username;
  final String? password;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final bool? status;
  final String? address;
  final bool? gender;
  final String? createAt;

  User({
    this.accountId,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.phone,
    this.status,
    this.address,
    this.gender,
    this.createAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountId': accountId,
      'username': username,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'status': status,
      'address': address,
      'gender': gender,
      'createAt': createAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      accountId: map['accountId'],
      username: map['username'],
      password: map['password'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      phone: map['phone'],
      status: map['status'],
      address: map['address'],
      gender: map['gender'],
      createAt: map['createAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
