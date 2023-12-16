import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/common/widgets/custom_textfield.dart';
import 'package:mobile_solar_mp/constants/enum.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/auth/service/auth_service.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = RoutePath.authRoute;
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKeySignIn = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignUp = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  var currentPage = CurrentPage.SIGN_IN_PAGE;

  final AuthService authService = AuthService();

  var _isLoading = false;
  var _gender = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void handleClickSignIn() {
    setState(() {
      currentPage = CurrentPage.SIGN_IN_PAGE;
      _formKeySignIn.currentState?.reset();
    });
  }

  void handleClickSignUp() {
    setState(() {
      currentPage = CurrentPage.SIGN_UP_PAGE;
      _formKeySignUp.currentState?.reset();
    });
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await authService.signInUser(
        context: context,
        username: _usernameController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutePath.navigationBarRoute,
          (route) => false,
        );
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
          e.toString(),
          color: Colors.red,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signUpUser(
        context: context,
        userSignUp: UserSignUp(
          username: _usernameController.text,
          password: _passwordController.text,
          firstname: _firstNameController.text,
          lastname: _lastNameController.text,
          address: _addressController.text,
          gender: _gender,
          phone: _usernameController.text,
        ),
      );
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutePath.verificationRoute,
          (route) => false,
        );
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
          e.toString(),
          color: Colors.red,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Minh Phát',
          ),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: 'Đăng nhập',
              ),
              Tab(
                text: 'Đăng kí',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  _formKeySignIn.currentState?.reset();
                  _usernameController.clear();
                  _passwordController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                  break;
                case 1:
                  _formKeySignUp.currentState?.reset();
                  _firstNameController.clear();
                  _lastNameController.clear();
                  _addressController.clear();
                  _usernameController.clear();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  setState(() {
                    _gender = true;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                  break;
                default:
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: signInFormWidget(),
              ),
              signUpFormWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Form signInFormWidget() {
    return Form(
      key: _formKeySignIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Số điện thoại',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Mật khẩu',
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKeySignIn.currentState!.validate()) {
                              signInUser();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50)),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Đăng nhập'),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Text(
              'Liên hệ hỗ trợ: 0909643365',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Form signUpFormWidget() {
    return Form(
      key: _formKeySignUp,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      hintText: 'Họ',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      hintText: 'Tên',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: _addressController,
                hintText: 'Địa chỉ',
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField(
                value: _gender.toString(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Giới tính',
                ),
                items: listGenders
                    .map((Item item) => DropdownMenuItem<String>(
                          value: item.value.toString(),
                          child: Text(item.label),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == 'true') {
                      _gender = true;
                    } else {
                      _gender = false;
                    }
                  });
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Số điện thoại',
                ),
                keyboardType: TextInputType.phone,
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  } else {
                    if (value.trim().length != 10) {
                      return 'Số điện thoại phải có độ dài 10 kí tự';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                  labelText: 'Mật khẩu',
                ),
                validator: (String? value) {
                  if (value!.trim().isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  } else {
                    if (value.trim().length < 6) {
                      return 'Mật khẩu phải có độ dài 6 kí tự trở lên';
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
                    return 'Vui lòng nhập lại mật khẩu';
                  } else if (value.trim() != _passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKeySignUp.currentState!.validate()) {
                            signUpUser();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50)),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng kí'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
