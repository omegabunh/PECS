//Packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

//Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/top_bar.dart';

//Providers
import '../providers/authentication_provider.dart';

//Pages
import '../pages/profile_page.dart';
import '../pages/setting_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;

  late String uid;
  late String email;
  late String name;

  String? _name;

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

    return Builder(
      builder: (BuildContext _context) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            children: [
              TopBar(
                'User',
                primaryAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              CustomTextButton(
                onPressed: () {
                  _auth.logout();
                },
                text: "로그아웃",
                leftIcon: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.black45,
                  size: 25,
                ),
                rightIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black45,
                  size: 25,
                ),
              ),
              CustomTextButton(
                onPressed: () {
                  Navigator.push(
                    _context,
                    MaterialPageRoute(
                      builder: (_context) => ProfilePage(),
                    ),
                  );
                },
                text: "프로필 편집",
                leftIcon: Icon(
                  Icons.app_registration_outlined,
                  color: Colors.black45,
                  size: 25,
                ),
                rightIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black45,
                  size: 25,
                ),
              ),
              CustomTextButton(
                onPressed: () {
                  Navigator.push(
                    _context,
                    MaterialPageRoute(
                      builder: (_context) => SettingPage(),
                    ),
                  );
                },
                text: "설정",
                leftIcon: Icon(
                  Icons.settings,
                  color: Colors.black45,
                  size: 25,
                ),
                rightIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black45,
                  size: 25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
