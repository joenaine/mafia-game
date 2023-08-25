import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/constants/app_styles_const.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/pages/room/room_repository.dart';
import 'package:mafiagame/services/string_extensions.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_global_loader_widget.dart';
import 'package:mafiagame/widgets/nav_back.dart';
import 'package:mafiagame/widgets/text_tap.dart';

class RoomMainScreen extends StatefulWidget {
  const RoomMainScreen({super.key, required this.id});
  final String id;

  @override
  State<RoomMainScreen> createState() => _RoomMainScreenState();
}

class _RoomMainScreenState extends State<RoomMainScreen>
    with TickerProviderStateMixin {
  late LinearTimerController timerController = LinearTimerController(this);
  bool timerRunning = false;
  @override
  void initState() {
    super.initState();
    startTimer(20);
  }

  @override
  void dispose() {
    timerController.dispose();
    _timer.cancel();

    super.dispose();
  }

  late Timer _timer;
  int _start = 59;
  bool isTimerFinished = false;

  void startTimer(int value) {
    isTimerFinished = false;
    _start = value;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isTimerFinished = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  List<String> selectedCharactersList = [];

  void selectCharacter(String charName) {
    if (selectedCharactersList.contains(charName)) {
      selectedCharactersList.remove(charName);
    } else {
      selectedCharactersList.add(charName);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore
            .collection(CollectionName.rooms)
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GameModel gameModel = GameModel.fromFirestore(snapshot.data!);
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                leading: const NavBack(),
                title: Text(gameModel.roomId ?? ''),
                titleTextStyle:
                    const TextStyle(fontSize: 40, fontFamily: 'Bebas'),
              ),
              body: StreamBuilder(
                  stream: firestore
                      .collection(CollectionName.rooms)
                      .doc(widget.id)
                      .collection(CollectionName.characters)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CharacterModel> charactersList = [];
                      for (QueryDocumentSnapshot<Map<String, dynamic>> category
                          in snapshot.data!.docs) {
                        charactersList
                            .add(CharacterModel.fromFirestore(category));
                      }
                      int count = 0;
                      for (var i = 0; i < charactersList.length; i++) {
                        if (charactersList[i].name != null) {
                          count++;
                        }
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            if (gameModel.isSleepTime ?? false) ...[
                              Center(
                                  child: LinearTimer(
                                      onUpdate: () {
                                        setState(() {});
                                      },
                                      backgroundColor: AppColors.white,
                                      color: AppColors.error,
                                      controller: timerController,
                                      duration: Duration(
                                          seconds:
                                              gameModel.timerInSec ?? 10))),
                              const SizedBox(height: 16),
                              Text(
                                _start.toString(),
                                style: TextStyle(
                                    fontSize: 36,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'the mafia chooses a victim',
                                style: AppStyles.s24w500
                                    .copyWith(color: AppColors.white),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: charactersList
                                    .map((character) => Column(
                                          children: [
                                            if (character.name != null) ...[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        selectCharacter(
                                                            character.name!);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            border: selectedCharactersList
                                                                    .contains(
                                                                        character
                                                                            .name)
                                                                ? Border.all(
                                                                    strokeAlign:
                                                                        StrokeAlign
                                                                            .outside,
                                                                    width: 2,
                                                                    color: AppColors
                                                                        .error)
                                                                : const Border()),
                                                        child: SvgPicture.asset(
                                                          '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                          height: 60,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(ShortText.fromText(
                                                        character.name ?? ''))
                                                  ],
                                                ),
                                              )
                                            ]
                                          ],
                                        ))
                                    .toList(),
                              )
                            ],
                            //CHARACTERS
                            if (gameModel.isSleepTime != true)
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: charactersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  CharacterModel characterModel =
                                      charactersList[index];

                                  return characterModel.name != null
                                      ? ListTile(
                                          leading: SvgPicture.asset(
                                            '${AppAssets.avatar.icon}${characterModel.avatarIndex!}.svg',
                                            height: 40,
                                          ),
                                          minVerticalPadding: 16,
                                          title: Row(
                                            children: [
                                              Text(
                                                characterModel.name ?? '',
                                                style: const TextStyle(
                                                    fontSize: 30),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                  '(${CharacterId.characterListEng[characterModel.characterId! - 1]})')
                                            ],
                                          ),
                                          trailing: Text(
                                              CharacterStatus.statusListEnd[
                                                  characterModel.status! - 1]),
                                        )
                                      : const SizedBox();
                                },
                              ),
                            const SizedBox(height: 30),
                            Text(
                              '$count/${charactersList.length}',
                              style: TextStyle(
                                  fontSize: 48,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return AppLoaderWidget();
                    }
                  }),
              bottomNavigationBar: gameModel.isSleepTime == false
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 80,
                      child: AppButton(
                        text: 'Sleep',
                        onPressed: () async {
                          final response =
                              await RoomRepository.updateIsSleepTime(
                                  roomId: widget.id, isSleepTime: true);
                          if (response) {
                            timerController.reset();
                            timerController.start();
                            startTimer(gameModel.timerInSec ?? 10);
                            // setState(() {});
                          }
                        },
                        color: Theme.of(context).colorScheme.primary,
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 80,
                            child: TextTap(
                              text: 'Stop timer',
                              onPressed: () async {
                                final response =
                                    await RoomRepository.updateIsSleepTime(
                                        roomId: widget.id, isSleepTime: false);
                                if (response) {
                                  timerController.stop();
                                  _timer.cancel();
                                }
                              },
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 80,
                            child: AppButton(
                              text: 'Choose',
                              onPressed: () {},
                              color: selectedCharactersList.isNotEmpty
                                  ? AppColors.error
                                  : Theme.of(context).colorScheme.primary,
                            ))
                      ],
                    ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: const SizedBox(),
            );
          }
        });
  }
}
