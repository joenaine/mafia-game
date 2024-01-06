import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';

class AppLoaderWidget extends StatelessWidget {
  AppLoaderWidget({
    Key? key,
  }) : super(key: key);
  final isLoading = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
                backgroundColor: Theme.of(context).colorScheme.primary)));
  }
}
