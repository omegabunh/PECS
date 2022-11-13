// ignore_for_file: unused_field

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';

//Widgets
import '../widgets/rounded_button.dart';

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
    uid = _auth.chatUser.uid;
    name = _auth.chatUser.name;
    email = _auth.chatUser.email;

    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: const Text(
              'User',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
              ),
              height: _deviceHeight,
              width: _deviceWidth,
              child: Column(
                children: [
                  _logoutButton(),
                  _profileEditButton(),
                  _settingButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _logoutButton() {
    return CustomTextButton(
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.85,
      onPressed: () {
        _auth.logout();
      },
      text: "로그아웃",
      leftIcon: const Icon(
        Icons.person_outline_rounded,
        color: Colors.black45,
        size: 25,
      ),
      rightIcon: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black45,
        size: 25,
      ),
    );
  }

  Widget _profileEditButton() {
    return CustomTextButton(
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.85,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      },
      text: "프로필 수정",
      leftIcon: const Icon(
        Icons.app_registration_outlined,
        color: Colors.black45,
        size: 25,
      ),
      rightIcon: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black45,
        size: 25,
      ),
    );
  }

  Widget _settingButton() {
    return CustomTextButton(
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.85,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingPage(),
          ),
        );
      },
      text: "설정",
      leftIcon: const Icon(
        Icons.settings,
        color: Colors.black45,
        size: 25,
      ),
      rightIcon: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.black45,
        size: 25,
      ),
    );
  }
}
