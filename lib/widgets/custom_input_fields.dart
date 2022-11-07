// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

//Packages
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
        onSaved: (value) => onSaved(value!),
        obscureText: obscureText,
        validator: (value) {
          return RegExp(regEx).hasMatch(value!) ? null : message;
        },
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(18.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintText: hintText,
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
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
