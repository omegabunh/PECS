// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final String message;
  final TextInputType type;

  CustomTextFormField({
    Key? key,
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.obscureText,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15.0),
      child: TextFormField(
        onSaved: (_value) => onSaved(_value!),
        //cursorColor: Colors.black87,
        //style: const TextStyle(color: Colors.black87),
        obscureText: obscureText,
        validator: (_value) {
          return RegExp(regEx).hasMatch(_value!) ? null : message;
        },
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18.0),
          //fillColor: const Color(0xFFF5F6F9),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: hintText,
          //hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {Key? key,
      required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
      ),
    );
  }
}
