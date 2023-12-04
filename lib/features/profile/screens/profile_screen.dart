import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/config/providers/user_provider.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/features/change_password/screens/change_password_screen.dart';
import 'package:mobile_solar_mp/features/edit_profile/screens/edit_profile_screen.dart';
import 'package:mobile_solar_mp/features/history_construction_contract/screens/history_construction_contract.dart';
import 'package:mobile_solar_mp/utils/shared_preferences.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = RoutePath.profileRoute;
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.accountId == null) {
      String user = SharedPreferencesUtils.getUser().toString();
      userProvider.setUser(json.decode(user));
    }

    void logout() async {
      await SharedPreferencesUtils.clearStorage();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutePath.authRoute,
          (route) => false,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '${userProvider.user.firstname} ${userProvider.user.lastname}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text(
                    'Chỉnh sửa thông tin',
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    ),
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.password),
                  title: const Text(
                    'Thay đổi mật khẩu',
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  ),
                ),
                // const Divider(),
                // ListTile(
                //   leading: const Icon(Icons.content_paste_search_sharp),
                //   title: const Text(
                //     'Lịch sử hợp đồng',
                //   ),
                //   trailing: const Icon(Icons.keyboard_arrow_right),
                //   onTap: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //           const HistoryConstructionContractScreen(),
                //     ),
                //   ),
                // ),
                const Divider(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => logout(),
                    child: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ),
            const Center(
                child: Text(
              'Hotline: 0909643365',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
