import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/text_tap.dart';

import '../constants/app_styles_const.dart';

class AlertDialogCustom {
  static void customAlert(
    context, {
    required String title,
    required String? content,
    required String generalButton,
    String? subgeneralButton,
    required VoidCallback onTapGeneral,
    VoidCallback? onTapSubgeneral,
    Function()? onThen,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            contentTextStyle:
                AppStyles.s16w400.copyWith(color: AppColors.white),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.s32w400.copyWith(color: AppColors.white),
            ),
            content: content != null
                ? Text(
                    content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5, fontSize: 24),
                  )
                : null,
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            actions: [
              AppButton(text: generalButton, onPressed: onTapGeneral),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    TextTap(text: subgeneralButton, onPressed: onTapSubgeneral),
              )),
            ],
          );
        }).then(
      (value) {
        onThen;
      },
    );
  }

  static void customAlertDismissible(
    context, {
    required String title,
    required String? content,
    required String generalButton,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
            contentTextStyle:
                AppStyles.s16w400.copyWith(color: AppColors.white),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.s32w400.copyWith(color: AppColors.white),
            ),
            content: content != null
                ? Text(
                    content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5, fontSize: 24),
                  )
                : null,
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          );
        });
  }
}
