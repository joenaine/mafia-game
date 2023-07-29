import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
    this.text,
    this.onPressed,
  }) : super(key: key);
  final String? text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: AppColors.error, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      ),
    );
  }
}
