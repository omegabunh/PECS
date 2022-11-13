//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Widgets
import '../widgets/custom_input_fields.dart';

//Providers
import '../providers/authentication_provider.dart';

//Services
import '../services/navigation_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordPage();
  }
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  late AuthenticationProvider _auth;
  late double _deviceHeight;
  late double _deviceWidth;
  String? _email;
  final _loginFormKey = GlobalKey<FormState>();
  late NavigationService _navigation;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  Widget _buildUI() {
    return Scaffold(
      body: Form(
        key: _loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: _deviceHeight * 0.10,
                child: const Text(
                  '비밀번호 찾기',
                  style: TextStyle(
                    color: Color.fromRGBO(64, 127, 104, 1.0),
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: CustomTextFormField(
                  onSaved: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  regEx:
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`₩{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  hintText: 'Email',
                  obscureText: false,
                  message: '이메일을 입력해주십시요.',
                  type: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('이메일 전송'),
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    _loginFormKey.currentState!.save();
                    FocusScope.of(context).requestFocus(FocusNode());
                    _auth.resetPassword(_email!);
                  }
                },
              ),
              TextButton(
                child: const Text('로그인'),
                onPressed: () => _navigation.navigateToRoute('/login'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }
}
