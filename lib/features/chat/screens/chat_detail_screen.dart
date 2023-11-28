import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_solar_mp/config/providers/firebase_provider.dart';
import 'package:mobile_solar_mp/constants/app_color.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/chat/service/chat_service.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

class ChatDetailScreen extends StatefulWidget {
  static const String routeName = RoutePath.chatDetailRoute;
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => ChatDetailScreenState();
}

class ChatDetailScreenState extends State<ChatDetailScreen>
    with SingleTickerProviderStateMixin {
  final userId = SharedPreferencesUtils.getId();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getMessage();
  }

  void sendMessage() async {
    try {
      await ChatService().addMessage(message: _messageController.text);
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString(), color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nhắn tin với quản lý',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () => Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => NavigationBarApp(
        //           pageIndex: 3,
        //         ),
        //       ),
        //       (route) => false),
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.black,
        // ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Consumer<FirebaseProvider>(
                builder: (context, value, child) => value.messages.isEmpty
                    ? const Center(
                        child: Text('Không có tin nhắn'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 16.0,
                        ),
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          final messageReserved = value.messages.reversed
                              .toList(); // reverse your list here

                          return _userItem(
                            context,
                            messageReserved[index].content!,
                            messageReserved[index].createdAt!,
                            messageReserved[index].userIdSent == userId,
                          );
                        },
                        itemCount: value.messages.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10.0),
                      ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      labelText: 'Soạn tin ...',
                    ),
                    controller: _messageController,
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColor.primary,
                  child: IconButton(
                    onPressed: () => sendMessage(),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _userItem(
  BuildContext context,
  String message,
  Timestamp createdAt,
  bool isMeSend,
) {
  return Align(
    alignment: isMeSend ? Alignment.topRight : Alignment.topLeft,
    child: Container(
      width: 250,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
        color: isMeSend ? Colors.green[200] : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(message),
          Text(
            DateFormat('HH:mm dd/MM/yyyy').format(createdAt.toDate()),
            style: const TextStyle(fontSize: 10.0),
          )
        ],
      ),
    ),
  );
}
