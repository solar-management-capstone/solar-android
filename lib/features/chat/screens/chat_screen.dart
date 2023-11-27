import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/providers/firebase_provider.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = RoutePath.chatRoute;
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
      
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhắn tin'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => _userItem(context),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 1,
      ),
    );
  }
}

Widget _userItem(BuildContext context) {
  return const ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(
      'Hieu',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}
