//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/database_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';

//Providers
import '../providers/authentication_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  late String email;
  late String name;
  late String profileImage;
  late String uid;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late double _deviceHeight;
  late double _deviceWidth;
  String? _name;
  final _registerFormKey = GlobalKey<FormState>();

  Widget _buildUI() {
    uid = _auth.chatUser.uid;
    name = _auth.chatUser.name;
    email = _auth.chatUser.email;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: InkWell(
                child: const Text(
                  '완료',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () async {
                  if (_registerFormKey.currentState!.validate()) {
                    _registerFormKey.currentState!.save();
                    await _db.updateUser(uid, email, _name!);
                    await _auth.logout();
                  }
                },
              ),
            ),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              const Text(
                '닉네임',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _deviceHeight * 0.01,
              ),
              _registerForm(),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              _emailForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      child: Form(
        key: _registerFormKey,
        child: CustomTextFormField(
          onSaved: (value) {
            setState(() {
              _name = value;
            });
          },
          regEx: r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|a-z|A-Z]{2,8}$',
          hintText: name,
          obscureText: false,
          message: '2~8자 이내의 닉네임을 입력해주십시요.',
          type: TextInputType.text,
        ),
      ),
    );
  }

  Widget _emailForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Expanded(
              flex: 3,
              child: Text('이메일'),
            ),
            Expanded(
              flex: 4,
              child: Text(email),
            ),
          ],
        ),
      ),
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
