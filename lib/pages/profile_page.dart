//Packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_image.dart';
import '../widgets/top_bar.dart';
import '../widgets/rounded_button.dart';

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
  late CloudStorageService _cloudStorage;

  late String uid;
  late String email;
  late String name;
  late String profileImage;

  String? _name;
  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    uid = _auth.user.uid;
    name = _auth.user.name;
    email = _auth.user.email;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
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
            )
          ],
        ),
      ),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight * 0.06,
      width: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: CustomTextFormField(
          onSaved: (_value) {
            setState(() {
              _name = _value;
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
    return RoundedButton(
      name: '',
      height: 50,
      width: 50,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate()) {
          _registerFormKey.currentState!.save();
          await _db.updateUser(uid, email, _name!);
          await _auth.logout();
        }
      },
    );
  }
}
