// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/screen_navigation_const.dart';
import 'package:mafiagame/pages/create_game/create_game_screen.dart';
import 'package:mafiagame/pages/join_game/join_game_screen.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_hide_keyboard_widget.dart';
import 'package:mafiagame/widgets/text_tap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomIdController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    return AppHideKeyBoardWidget(
      child: Scaffold(
        backgroundColor: appColor.background,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    AppAssets.images.godfather,
                    height: 200,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'MAFIA Game',
                    style: TextStyle(fontSize: 64, color: Colors.white),
                  ),
                  Divider(
                    color: appColor.primary,
                    thickness: 4,
                  ),
                  const SizedBox(height: 70),
                  AppButton(
                    onPressed: () {
                      changeScreen(context, const CreateGameScreen());
                    },
                    text: 'Create Room',
                  ),
                  const SizedBox(height: 10),
                  TextTap(
                    onPressed: () {
                      changeScreen(context, const JoinGameScreen());
                    },
                    text: 'JOIN',
                  ),
                  const Align(
                      alignment: Alignment.bottomRight,
                      child: Text('by 2handaulet'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
