//Packages
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.onPressed,
  });

  final double height;
  final String name;
  final Function onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.25),
        color: const Color.fromRGBO(64, 200, 104, 1.0),
      ),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          name,
          style:
              const TextStyle(fontSize: 22, color: Colors.white, height: 1.5),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.height,
    required this.width,
    required this.leftIcon,
    required this.rightIcon,
  }) : super(key: key);

  final double height;
  final Icon leftIcon;
  final Function() onPressed;
  final Icon rightIcon;
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.25),
            color: Colors.lightGreen[50],
          ),
          child: TextButton(
            onPressed: () => onPressed(),
            child: Row(
              children: [
                leftIcon,
                const SizedBox(width: 20),
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
        ),
      ],
    );
  }
}
