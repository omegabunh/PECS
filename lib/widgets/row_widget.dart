import 'package:flutter/cupertino.dart';

Widget statsRow(String label, String value) {
  Widget row = Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          //flex: 3,
          child: Text(label),
        ),
        Expanded(
          //flex: 4,
          child: Text(value),
        ),
      ],
    ),
  );
  return row;
}
