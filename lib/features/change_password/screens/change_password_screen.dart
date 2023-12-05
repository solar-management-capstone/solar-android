import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/common/widgets/custom_button.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/change_password/service/change_password_service.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = RoutePath.changePasswordRoute;
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void handleChangePassword() async {
    try {
      await ChangePasswordService().changePassword(
        context: context,
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (mounted) {
        showSnackBar(context, 'Đổi mật khẩu thành công');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarApp(
                pageIndex: 4,
              ),
            ),
            (route) => false);
      }
    } on CustomException catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          e.cause,
          color: Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
          context,
          'Đổi mật khẩu thất bại',
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationBarApp(
                  pageIndex: 4,
                ),
              ),
              (route) => false),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Thay đổi mật khẩu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Mật khẩu cũ',
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Vui lòng nhập mật khẩu cũ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Mật khẩu mới',
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  } else {
                    if (value.trim().length < 6 || value.trim().length > 8) {
                      return 'Mật khẩu phải có độ dài 6 đến 8 kí tự';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Nhập lại mật khẩu',
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Vui lòng nhập lại mật khẩu mới';
                  } else if (value.trim() != _newPasswordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomButton(
                text: 'Xác nhận',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    handleChangePassword();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
