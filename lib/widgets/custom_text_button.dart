import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Icon leftIcon;
  final Icon rightIcon;

  CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.leftIcon,
    required this.rightIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5F6F9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              onPressed();
            },
            child: Row(
              children: [
                leftIcon,
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                rightIcon,
              ],
            ),
          ),
        )
      ],
    );
  }
}
