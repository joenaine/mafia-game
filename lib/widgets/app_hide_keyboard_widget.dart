import 'package:flutter/material.dart';

/// обверните виджет как родительский и при нажатии на любую область будет скрыта клавиатура
class AppHideKeyBoardWidget extends StatelessWidget {
  final Widget child;

  const AppHideKeyBoardWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: child,
      );
}
