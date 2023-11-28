import 'package:flutter/material.dart';
import 'package:mobile_solar_mp/common/handle_exception/bad_request_exception.dart';
import 'package:mobile_solar_mp/common/widgets/custom_textfield.dart';
import 'package:mobile_solar_mp/constants/global_variables.dart';
import 'package:mobile_solar_mp/constants/routes.dart';
import 'package:mobile_solar_mp/constants/utils.dart';
import 'package:mobile_solar_mp/features/edit_profile/service/edit_profile_service.dart';
import 'package:mobile_solar_mp/features/navigation_bar/navigation_bar_app.dart';
import 'package:mobile_solar_mp/models/account.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = RoutePath.editProfileRoute;
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _accountId = TextEditingController();

  String _gender = 'true';
  bool _isLoading = false;

  late Future<Account> _dataFuture;

  Future<Account> getUser() async {
    Account user = Account();
    try {
      user = await EditProfileService().getUser();
      _firstName.text = user.firstname!;
      _lastName.text = user.lastname!;
      _phone.text = user.phone!;
      _address.text = user.address!;
      _accountId.text = user.accountId!;
      setState(() {
        _gender = user.gender! == true ? 'true' : 'false';
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString(), color: Colors.red);
      }
    }
    return user;
  }

  @override
  void initState() {
    super.initState();

    _dataFuture = getUser();
  }

  void submitData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await EditProfileService().updateUser(
        context: context,
        accountId: _accountId.text,
        firstname: _firstName.text,
        lastname: _lastName.text,
        address: _address.text,
        gender: _gender == 'true' ? true : false,
      );

      FocusManager.instance.primaryFocus?.unfocus();
      if (mounted) {
        showSnackBar(
          context,
          'Cập nhật thành công',
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBarApp(
              pageIndex: 4,
            ),
          ),
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
          // 'Cập nhật không thành công',
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
        title: const Text('Chỉnh sửa thông tin'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: FutureBuilder<Account>(
          future: _dataFuture,
          builder: (BuildContext build, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstName,
                              hintText: 'Họ',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastName,
                              hintText: 'Tên',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _address,
                        hintText: 'Địa chỉ',
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      DropdownButtonFormField(
                        value: _gender,
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
                            .map(
                              (Item item) => DropdownMenuItem<String>(
                                value: item.value,
                                child: Text(item.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _gender = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _phone,
                        hintText: 'Số điện thoại',
                        readOnly: true,
                      ),
                      const SizedBox(height: 35.0),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  submitData();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50)),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Lưu'),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
