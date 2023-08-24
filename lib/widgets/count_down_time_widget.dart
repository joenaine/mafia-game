import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:pie_timer/pie_timer.dart';

class CountDownTimer extends StatelessWidget {
  const CountDownTimer(
      {Key? key, this.duration = 10, this.pieAnimationController})
      : super(key: key);
  final int? duration;
  final PieAnimationController? pieAnimationController;

  @override
  Widget build(BuildContext context) {
    return PieTimer(
      duration: Duration(seconds: duration!),
      radius: 150,
      pieAnimationController: pieAnimationController,
      fillColor: AppColors.error,
      pieColor: Theme.of(context).colorScheme.background,
      borderColor: Colors.white,
      borderWidth: 15,
      shadowColor: Colors.black,
      shadowElevation: 10.0,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      isReverse: false,
      onCompleted: () => {},
      onDismissed: () => {},
      // enableTouchControls: true,
    );
  }
}
