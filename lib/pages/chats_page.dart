//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Pages
import '../pages/login_page.dart';
import 'register_page.dart';

class ChatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  //final items = <Todo>[];
  final _loginFormKey = GlobalKey<FormState>();

  String? _text;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            children: [
              _registter(),
              // StreamBuilder<QuerySnapshot>(
              //   stream: FirebaseFirestore.instance
              //       .collection("Todos")
              //       .doc(uid)
              //       .collection("todo")
              //       .snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const CircularProgressIndicator.adaptive();
              //     }
              //     final documents = snapshot.data!.docs;
              //     return Expanded(
              //       child: ListView(
              //         children:
              //             documents.map((doc) => _toDoListView(doc)).toList(),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registter() {
    return Builder(builder: (BuildContext _context) {
      return OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("유저 등록"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        _context,
                        MaterialPageRoute(
                          builder: (_context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text("로그인"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        _context,
                        MaterialPageRoute(
                          builder: (_context) => RegisterPage(),
                        ),
                      );
                    },
                    child: const Text("회원 등록"),
                  )
                ],
              );
            },
          );
        },
        child: const Text("로그인"),
      );
    });
  }
}
