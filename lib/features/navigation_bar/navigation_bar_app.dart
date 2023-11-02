import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/constants/app_color.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/features/home/screens/home_screen.dart';
import 'package:mobile_solar_mp/features/profile/screens/profile_screen.dart';

class NavigationBarApp extends StatefulWidget {
  static const String routeName = RoutePath.navigationBarRoute;
  const NavigationBarApp({super.key});

  @override
  State<NavigationBarApp> createState() => _NavigationBarAppState();
}

class _NavigationBarAppState extends State<NavigationBarApp> {
  int _currentPageIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: AppColor.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.content_paste_search_sharp),
            label: 'Hợp đồng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: _currentPageIndex,
        onTap: _onItemTapped,
      ),
      body: const [
        HomeScreen(),
        SafeArea(
          child: Center(
            child: Text('Contract'),
          ),
        ),
        SafeArea(
          child: Center(
            child: Text('Chat'),
          ),
        ),
        ProfileScreen(),
      ][_currentPageIndex],
    );
  }
}
