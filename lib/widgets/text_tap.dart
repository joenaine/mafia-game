import 'package:flutter/material.dart';

class TextTap extends StatelessWidget {
  const TextTap(
      {Key? key, this.text, this.onPressed, this.color = Colors.white})
      : super(key: key);
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text ?? '',
        style: TextStyle(fontSize: 32, color: color),
      ),
    );
  }
}
