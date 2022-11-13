// ignore_for_file: avoid_print, body_might_complete_normally_nullable

//Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttertoast/fluttertoast.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Models
import '../models/chat_user.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUser chatUser;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _databaseService.getUser(user.uid).then(
          (snapshot) {
            Map<String, dynamic> userData =
                snapshot.data()! as Map<String, dynamic>;
            chatUser = ChatUser.fromJSON(
              {
                "uid": user.uid,
                "name": userData["name"],
                "email": userData["email"],
              },
            );
            _navigationService.removeAndNavigateToRoute('/home');
          },
        );
      } else {
        _navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      Fluttertoast.showToast(
        msg: "아이디 또는 비밀번호가 잘못 입력 되었습니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 10,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code.toString() == 'invalid-email') {
        Fluttertoast.showToast(
          msg: "이메일형식이 아닙니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 10,
        );
      }

      if (e.code.toString() == 'missing-email') {
        Fluttertoast.showToast(
          msg: "이메일을 잘못 입력하였습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 10,
        );
      }

      if (e.code.toString() == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "유저를 찾을 수 없습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 10,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      Fluttertoast.showToast(
        msg: "이미 존재하는 이메일입니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 10,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
