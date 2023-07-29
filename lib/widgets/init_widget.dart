import 'package:flutter/material.dart';
import 'package:mafiagame/pages/create_game/create_game_provider.dart';
import 'package:mafiagame/pages/join_game/join_game_provider.dart';

import 'package:provider/provider.dart';

class InitWidget extends StatelessWidget {
  const InitWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CreateGameProvider()),
        ChangeNotifierProvider(create: (context) => JoinGameProvider()),
      ],
      child: child,
    );
  }
}
