import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mafiagame/constants/app_assets.dart';

class NavBack extends StatelessWidget {
  const NavBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset(
          AppAssets.svg.arrowleft,
          color: Colors.white,
        ));
  }
}
