//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/database_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

//Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late double _deviceHeight;
  late double _deviceWidth;
  String? _email;
  String? _name;
  String? _password;
  final _registerFormKey = GlobalKey<FormState>();

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _registerForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _registerButton(),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
            ],
          )),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  _name = value;
                });
              },
              regEx: r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|a-z|A-Z]{2,8}$',
              hintText: "Name",
              obscureText: false,
              message: '2~8자 이내의 닉네임을 입력해주십시요.',
              type: TextInputType.text,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  _email = value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: "Email",
              obscureText: false,
              message: '이메일 항목을 입력해주십시요.',
              type: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              onSaved: (value) {
                setState(() {
                  _password = value;
                });
              },
              regEx: r".{8,}",
              hintText: "Password",
              obscureText: true,
              message: '비밀번호 8자리 이상 입력해주십시요.',
              type: TextInputType.visiblePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "회원가입",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();
          String? uid = await _auth.registerUserUsingEmailAndPassword(
              _email!, _password!);

          await _db.createUser(uid!, _email!, _name!);
          await _auth.logout();
          await _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }
}
