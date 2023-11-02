import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalBottomSheetCustom {
  static void moreModalBottomSheet(
      context, double height, double horizontal, List<Widget> children,
      {void Function()? func}) {
    Size size = MediaQuery.of(context).size;
    showMaterialModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: const Border(top: BorderSide(color: AppColors.white))),
            height: height,
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16, horizontal: horizontal),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ).whenComplete(func ?? () {});
  }
}
