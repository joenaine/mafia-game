import 'package:flutter/material.dart';

void changeScreen(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void rootPop(
  BuildContext context,
) {
  Navigator.of(context, rootNavigator: true).pop();
}

void screenPop(
  BuildContext context,
) {
  Navigator.pop(context);
}

// request here
void changeScreenReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

void changeScreenByRemove(BuildContext context, Widget widget, String route) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      ModalRoute.withName(route));
}
