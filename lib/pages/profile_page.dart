//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/database_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/top_bar.dart';

//Pages
import '../pages/user_page.dart';

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
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;

  late String uid;
  late String email;
  late String name;
  late String profileImage;

  String? _name;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    uid = _auth.chatUser.uid;
    name = _auth.chatUser.name;
    email = _auth.chatUser.email;

    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Edit profile',
                primaryAction: IconButton(
                  icon: Icon(
                    Icons.adaptive.arrow_forward,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPage(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _registerForm(),
                  _nameEditButton(),
                ],
              ),
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
      height: _deviceHeight * 0.06,
      width: _deviceHeight * 0.4,
      child: Form(
        key: _registerFormKey,
        child: CustomTextFormField(
          onSaved: (value) {
            setState(() {
              _name = value;
            });
          },
          regEx: r'^[ㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]{2,6}$',
          hintText: name,
          obscureText: false,
          message: '2~6자 이내의 이름을 입력해주십시요.',
          type: TextInputType.text,
        ),
      ),
    );
  }

  Widget _nameEditButton() {
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(64, 200, 104, 1.0),
      ),
      child: IconButton(
        onPressed: () async {
          if (_registerFormKey.currentState!.validate()) {
            _registerFormKey.currentState!.save();
            await _db.updateUser(uid, email, _name!);
            await _auth.logout();
          }
        },
        icon: const Icon(
          Icons.save_alt,
          color: Colors.white,
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
}
