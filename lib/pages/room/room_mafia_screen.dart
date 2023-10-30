import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:linear_timer/linear_timer.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/constants/app_styles_const.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/constants/screen_navigation_const.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/join_game/join_game_provider.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/pages/room/room_repository.dart';
import 'package:mafiagame/services/string_extensions.dart';
import 'package:mafiagame/widgets/alert_dialog.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_overlay_widget.dart';
import 'package:mafiagame/widgets/nav_back.dart';
import 'package:mafiagame/widgets/text_tap.dart';
import 'package:provider/provider.dart';

class RoomMafiaScreen extends StatefulWidget {
  const RoomMafiaScreen({super.key, required this.id, this.name});
  final String id;
  final String? name;

  @override
  State<RoomMafiaScreen> createState() => _RoomMafiaScreenState();
}

class _RoomMafiaScreenState extends State<RoomMafiaScreen>
    with TickerProviderStateMixin {
  late LinearTimerController timerController;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    timerController = LinearTimerController(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isTimerRunning =
          await RoomRepository.getIfGameStarted(roomId: widget.id);

      setState(() {});
    });
  }

  @override
  void dispose() async {
    timerController.dispose();
    await player.dispose();
    // _timer.cancel();

    super.dispose();
  }

  final player = AudioPlayer();

  Future<void> playMafiaTime() async {
    await player.setSource(AssetSource('sounds/mafias.mp3'));
    await player.resume();
  }

  Future<void> playDoctorTime() async {
    await stopPlayer();
    await player.setSource(AssetSource('sounds/doctors.mp3'));
    await player.resume();
  }

  Future<void> playSilencerTime() async {
    await stopPlayer();
    await player.setSource(AssetSource('sounds/silencers.mp3'));
    await player.resume();
  }

  Future<void> playDetectiveTime() async {
    stopPlayer();
    await player.setSource(AssetSource('sounds/detectives.mp3'));
    await player.resume();
  }

  Future<void> stopPlayer() async {
    await player.stop();
  }

  void stopTimer() {
    timerController.stop();
    // timerController.start();
    timerController.reset();

    // _timer.cancel();
    // selectedMafiaCharactersList.clear();
  }

  List<CharacterModel> selectedMafiaCharactersList = [];
  List<CharacterModel> selectedDoctorCharactersList = [];
  List<CharacterModel> selectedSilencerCharactersList = [];

  void selectMafiaCharacter(CharacterModel char) {
    if (selectedMafiaCharactersList
        .any((element) => element.name == char.name)) {
      selectedMafiaCharactersList
          .removeWhere((element) => element.name == char.name);
    } else {
      selectedMafiaCharactersList.add(char);
    }
    setState(() {});
  }

  void selectDoctorCharacter(CharacterModel char) {
    if (selectedDoctorCharactersList
        .any((element) => element.name == char.name)) {
      selectedDoctorCharactersList
          .removeWhere((element) => element.name == char.name);
    } else {
      selectedDoctorCharactersList.add(char);
    }
    setState(() {});
  }

  void selectSilencerCharacter(CharacterModel char) {
    if (selectedSilencerCharactersList
        .any((element) => element.name == char.name)) {
      selectedSilencerCharactersList
          .removeWhere((element) => element.name == char.name);
    } else {
      selectedSilencerCharactersList.add(char);
    }
    setState(() {});
  }

  bool detectiveGuessedCharacter = false;

  bool guessMafiaFunction(CharacterModel characterModel) {
    if (characterModel.characterId == 2) {
      AlertDialogCustom.customAlertDismissible(
        context,
        title: '${characterModel.name} is Mafia',
        content: null,
        generalButton: 'Back',
      );
      return true;
    } else {
      AlertDialogCustom.customAlertDismissible(
        context,
        title: '${characterModel.name} is not a Mafia',
        content: null,
        generalButton: 'Back',
      );
      return true;
    }
  }

  GameModel gameModel = GameModel(
      isDetectiveTime: false,
      isDoctorTime: false,
      isMafiaTime: false,
      isSilencerTime: false,
      isTimeController: false,
      isSleepTime: false);

  bool isLoading = false;
  bool isMafia = true;
  bool isLoadingSleepButton = false;

  void clearSelectionList() {
    selectedMafiaCharactersList.clear();
    selectedDoctorCharactersList.clear();
    selectedSilencerCharactersList.clear();
  }

  bool isRolesShown = false;

  bool isMyRoleShown = false;

  @override
  Widget build(BuildContext context) {
    final meInit = Provider.of<JoinGameProvider>(context);
    return AppOverlayLoadingWidget(
      isLoading: isLoadingSleepButton,
      child: WillPopScope(
        onWillPop: () {
          // timerController.dispose();
          // _timer.cancel();
          return Future((() => true));
        },
        child: _isTimerRunning
            ? Scaffold(
                appBar: AppBar(),
                body: const Text('The Game is in a Sleeping Mode'))
            : StreamBuilder(
                stream: firestore
                    .collection(CollectionName.rooms)
                    .doc(widget.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    GameModel gameModelRaw =
                        GameModel.fromFirestore(snapshot.data!);
                    gameModel.createdBy = gameModelRaw.createdBy;
                    gameModel.timerInSec = gameModelRaw.timerInSec;
                    gameModel.isSleepTime = gameModelRaw.isSleepTime;

                    return StreamBuilder(
                        stream: firestore
                            .collection(CollectionName.rooms)
                            .doc(widget.id)
                            .collection(CollectionName.characters)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<CharacterModel> charactersList = [];
                            for (QueryDocumentSnapshot<
                                    Map<String, dynamic>> category
                                in snapshot.data!.docs) {
                              charactersList
                                  .add(CharacterModel.fromFirestore(category));
                            }
                            int count = 0;
                            for (int i = 0; i < charactersList.length; i++) {
                              if (charactersList[i].name != null &&
                                  charactersList[i].status != 2) {
                                count++;
                                if (charactersList[i].name == widget.name) {
                                  meInit.myCharacter = charactersList[i];
                                }
                              }
                            }

                            if (gameModelRaw.isSleepTime == true) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                gameModel.isMafiaTime = isMafia;

                                timerController.start();
                                if (gameModel.isMafiaTime!) {
                                  await playMafiaTime();
                                }

                                // startTimer(gameModel.timerInSec ?? 10);
                              });
                            }
                            return Scaffold(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                appBar: AppBar(
                                  leading: NavBack(
                                    onWillPop: () {
                                      // stopTimer();
                                    },
                                  ),
                                  title: Text(gameModelRaw.roomId ?? ''),
                                  actions: [
                                    if (gameModelRaw.createdBy ==
                                        meInit.myCharacter?.name)
                                      IconButton(
                                          onPressed: () {
                                            AlertDialogCustom.customAlert(
                                              context,
                                              title: 'Show Character Roles',
                                              content:
                                                  'Do you want to see roles of all characters"',
                                              generalButton: 'Show',
                                              subgeneralButton: 'Hide',
                                              onTapGeneral: () async {
                                                screenPop(context);
                                                isRolesShown = true;
                                                setState(() {});
                                              },
                                              onTapSubgeneral: () {
                                                screenPop(context);
                                                isRolesShown = false;
                                                setState(() {});
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                              Icons.remove_red_eye_outlined)),
                                    IconButton(
                                        onPressed: () async {
                                          AlertDialogCustom.customAlert(
                                            context,
                                            title: 'New Game',
                                            content:
                                                'Do you want to change status of all characters to "Alive"',
                                            generalButton: 'Restart',
                                            subgeneralButton: 'Back',
                                            onTapGeneral: () async {
                                              screenPop(context);
                                              await RoomRepository
                                                  .resetAllCharacters(
                                                      roomId: widget.id,
                                                      charlength: charactersList
                                                          .length);
                                            },
                                            onTapSubgeneral: () {
                                              screenPop(context);
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.refresh)),
                                  ],
                                  titleTextStyle: const TextStyle(
                                      fontSize: 40, fontFamily: 'Bebas'),
                                ),
                                body: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (gameModel.isSleepTime ?? false) ...[
                                        if (gameModel.isMafiaTime == true) ...[
                                          Center(
                                              child: LinearTimer(
                                                  onTimerEnd: () async {
                                                    gameModel.isMafiaTime =
                                                        false;
                                                    isMafia = false;
                                                    gameModel.isDoctorTime =
                                                        true;
                                                    setState(() {});

                                                    timerController.reset();
                                                    await playDoctorTime();
                                                    timerController.start();
                                                  },
                                                  backgroundColor:
                                                      AppColors.white,
                                                  color: AppColors.error,
                                                  controller: timerController,
                                                  duration: Duration(
                                                      seconds: gameModel
                                                              .timerInSec ??
                                                          10))),
                                          const SizedBox(height: 16),
                                          // Text(
                                          //   _start.toString(),
                                          //   style: TextStyle(
                                          //       fontSize: 36,
                                          //       color: Theme.of(context)
                                          //           .colorScheme
                                          //           .secondary),
                                          // ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'the mafia chooses a victim',
                                            style: AppStyles.s24w500.copyWith(
                                                color: AppColors.white),
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            children: charactersList
                                                .map((character) => Column(
                                                      children: [
                                                        if (character.name !=
                                                                null &&
                                                            character.status !=
                                                                2) ...[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (meInit
                                                                            .myCharacter
                                                                            ?.characterId ==
                                                                        2) {
                                                                      selectMafiaCharacter(
                                                                          character);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40),
                                                                        border: selectedMafiaCharactersList.any((element) => element.name == character.name)
                                                                            ? Border.all(
                                                                                strokeAlign: StrokeAlign.outside,
                                                                                width: 2,
                                                                                color: AppColors.error)
                                                                            : const Border()),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                      height:
                                                                          60,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(ShortText
                                                                    .fromText(
                                                                        character.name ??
                                                                            ''))
                                                              ],
                                                            ),
                                                          )
                                                        ]
                                                      ],
                                                    ))
                                                .toList(),
                                          )
                                        ],
                                        //DOCTOR TIME
                                        if (gameModel.isDoctorTime == true) ...[
                                          Center(
                                              child: LinearTimer(
                                                  onTimerEnd: () async {
                                                    gameModel.isDoctorTime =
                                                        false;
                                                    gameModel.isSilencerTime =
                                                        true;
                                                    setState(() {});
                                                    timerController.reset();
                                                    await playSilencerTime();
                                                    timerController.start();
                                                  },
                                                  backgroundColor:
                                                      AppColors.white,
                                                  color: AppColors.error,
                                                  controller: timerController,
                                                  duration: Duration(
                                                      seconds: gameModel
                                                              .timerInSec ??
                                                          10))),
                                          const SizedBox(height: 16),
                                          // Text(
                                          //   _start.toString(),
                                          //   style: TextStyle(
                                          //       fontSize: 36,
                                          //       color: Theme.of(context)
                                          //           .colorScheme
                                          //           .secondary),
                                          // ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'the doctor chooses a player to protect',
                                            style: AppStyles.s24w500.copyWith(
                                                color: AppColors.white),
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            children: charactersList
                                                .map((character) => Column(
                                                      children: [
                                                        if (character.name !=
                                                                null &&
                                                            character.status !=
                                                                2) ...[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (meInit
                                                                            .myCharacter
                                                                            ?.characterId ==
                                                                        3) {
                                                                      selectDoctorCharacter(
                                                                          character);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40),
                                                                        border: selectedDoctorCharactersList.any((element) => element.name == character.name)
                                                                            ? Border.all(
                                                                                strokeAlign: StrokeAlign.outside,
                                                                                width: 2,
                                                                                color: AppColors.error)
                                                                            : const Border()),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                      height:
                                                                          60,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(ShortText
                                                                    .fromText(
                                                                        character.name ??
                                                                            ''))
                                                              ],
                                                            ),
                                                          )
                                                        ]
                                                      ],
                                                    ))
                                                .toList(),
                                          )
                                        ],
                                        //SILENCER TIME
                                        if (gameModel.isSilencerTime ==
                                            true) ...[
                                          Center(
                                              child: LinearTimer(
                                                  onTimerEnd: () async {
                                                    gameModel.isSilencerTime =
                                                        false;
                                                    gameModel.isDetectiveTime =
                                                        true;
                                                    setState(() {});
                                                    timerController.reset();
                                                    await playDetectiveTime();
                                                    timerController.start();
                                                  },
                                                  backgroundColor:
                                                      AppColors.white,
                                                  color: AppColors.error,
                                                  controller: timerController,
                                                  duration: Duration(
                                                      seconds: gameModel
                                                              .timerInSec ??
                                                          10))),
                                          const SizedBox(height: 16),
                                          // Text(
                                          //   _start.toString(),
                                          //   style: TextStyle(
                                          //       fontSize: 36,
                                          //       color: Theme.of(context)
                                          //           .colorScheme
                                          //           .secondary),
                                          // ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'the silencer chooses a player to mute',
                                            style: AppStyles.s24w500.copyWith(
                                                color: AppColors.white),
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            children: charactersList
                                                .map((character) => Column(
                                                      children: [
                                                        if (character.name !=
                                                                null &&
                                                            character.status !=
                                                                2) ...[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (meInit
                                                                            .myCharacter
                                                                            ?.characterId ==
                                                                        5) {
                                                                      selectSilencerCharacter(
                                                                          character);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40),
                                                                        border: selectedSilencerCharactersList.any((element) => element.name == character.name)
                                                                            ? Border.all(
                                                                                strokeAlign: StrokeAlign.outside,
                                                                                width: 2,
                                                                                color: AppColors.error)
                                                                            : const Border()),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                      height:
                                                                          60,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(ShortText
                                                                    .fromText(
                                                                        character.name ??
                                                                            ''))
                                                              ],
                                                            ),
                                                          )
                                                        ]
                                                      ],
                                                    ))
                                                .toList(),
                                          )
                                        ],
                                        //DETECTIVE TIME
                                        if (gameModel.isDetectiveTime ==
                                            true) ...[
                                          Center(
                                              child: LinearTimer(
                                                  onTimerEnd: () async {
                                                    await RoomRepository
                                                        .deleteCollectionSelectedChars(
                                                            widget.id);
                                                    gameModel.isDetectiveTime =
                                                        false;
                                                    await stopPlayer();

                                                    final isSleep =
                                                        await RoomRepository
                                                                .setSleepModeOff(
                                                                    roomId:
                                                                        widget
                                                                            .id,
                                                                    docId: meInit
                                                                        .myCharacter!
                                                                        .docId!)
                                                            .then(
                                                                (value) async {
                                                      await RoomRepository.sendSelectedCharacters(
                                                          roomId: widget.id,
                                                          docId: meInit
                                                              .myCharacter!
                                                              .docId!,
                                                          selectedDoctorDocIds:
                                                              selectedDoctorCharactersList,
                                                          selectedMafiaDocIds:
                                                              selectedMafiaCharactersList,
                                                          selectedSilencerDocIds:
                                                              selectedSilencerCharactersList);
                                                      await RoomRepository
                                                          .isAllCharactersSleepOff(
                                                        roomId: widget.id,
                                                      ).then((value) async {
                                                        setState(() {});
                                                        timerController.reset();
                                                      });
                                                    });
                                                    List<CharacterModel>
                                                        aliveCharsList = [];

                                                    for (var i = 0;
                                                        i <
                                                            charactersList
                                                                .length;
                                                        i++) {
                                                      if (charactersList[i]
                                                              .status !=
                                                          CharacterStatus
                                                              .dead) {
                                                        aliveCharsList.add(
                                                            charactersList[i]);
                                                      }
                                                    }

                                                    bool isResult =
                                                        await RoomRepository
                                                            .showResults(
                                                                roomId:
                                                                    widget.id,
                                                                length:
                                                                    aliveCharsList
                                                                        .length);
                                                    print(
                                                        '$isResult Bool IsResult LENGTH');

                                                    if (isResult) {
                                                      await RoomRepository
                                                              .getSelectedCharacters(
                                                                  roomId:
                                                                      widget.id)
                                                          .then((value) async {
                                                        AlertDialogCustom
                                                            .customAlert(
                                                          context,
                                                          title: 'Result',
                                                          content: value,
                                                          generalButton: 'ok',
                                                          onTapGeneral: () {
                                                            screenPop(context);
                                                          },
                                                        );
                                                      });
                                                    }

                                                    // await RoomRepository
                                                    //         .getIsSleepTimeOff(
                                                    //             roomId:
                                                    //                 widget.id)
                                                    //     .then((value) async {
                                                    //   if (value) {
                                                    //
                                                    //         .then(
                                                    //             (value) async {
                                                    //       await RoomRepository
                                                    //           .clearSelectedChars(
                                                    //               widget.id);

                                                    //       AlertDialogCustom
                                                    //           .customAlert(
                                                    //         context,
                                                    //         title: 'Result',
                                                    //         content: value,
                                                    //         generalButton: 'ok',
                                                    //         onTapGeneral: () {
                                                    //           screenPop(
                                                    //               context);
                                                    //         },
                                                    //       );
                                                    // });
                                                    // }
                                                    // });

                                                    //TODO: ADD COUNTER IF ALL USERS HAD SENT

                                                    //TODO: THEN ADD STATEMENT IF ALL HAD SENT
                                                  },
                                                  backgroundColor:
                                                      AppColors.white,
                                                  color: AppColors.error,
                                                  controller: timerController,
                                                  duration: Duration(
                                                      seconds: gameModel
                                                              .timerInSec ??
                                                          10))),
                                          const SizedBox(height: 16),
                                          // Text(
                                          //   _start.toString(),
                                          //   style: TextStyle(
                                          //       fontSize: 36,
                                          //       color: Theme.of(context)
                                          //           .colorScheme
                                          //           .secondary),
                                          // ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'the detective guesses a mafia',
                                            style: AppStyles.s24w500.copyWith(
                                                color: AppColors.white),
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            alignment: WrapAlignment.center,
                                            children: charactersList
                                                .map((character) => Column(
                                                      children: [
                                                        if (character.name !=
                                                                null &&
                                                            character.status !=
                                                                2) ...[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (meInit
                                                                            .myCharacter
                                                                            ?.characterId ==
                                                                        4) {
                                                                      detectiveGuessedCharacter =
                                                                          guessMafiaFunction(
                                                                              character);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(3),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                40),
                                                                        border: selectedSilencerCharactersList.any((element) => element.name == character.name)
                                                                            ? Border.all(
                                                                                strokeAlign: StrokeAlign.outside,
                                                                                width: 2,
                                                                                color: AppColors.error)
                                                                            : const Border()),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                      height:
                                                                          60,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 8),
                                                                Text(ShortText
                                                                    .fromText(
                                                                        character.name ??
                                                                            ''))
                                                              ],
                                                            ),
                                                          )
                                                        ]
                                                      ],
                                                    ))
                                                .toList(),
                                          )
                                        ],
                                      ],
                                      //CHARACTERS
                                      if (gameModel.isSleepTime != true)
                                        ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: charactersList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            CharacterModel characterModel =
                                                charactersList[index];
                                            timerController.reset();
                                            if (detectiveGuessedCharacter) {
                                              screenPop(context);
                                              detectiveGuessedCharacter = false;
                                            }

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
                                                          characterModel.name ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 30),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        if (isRolesShown)
                                                          Text(
                                                              '(${CharacterId.characterListEng[characterModel.characterId! - 1]})'),
                                                        if (meInit.myCharacter
                                                                ?.name ==
                                                            characterModel.name)
                                                          const Text(
                                                            ' (me)',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .error),
                                                          ),
                                                        if (characterModel
                                                                .isSleepModeOn ??
                                                            false)
                                                          const Text(
                                                            ' sleep',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .success),
                                                          )
                                                      ],
                                                    ),
                                                    trailing: Text(
                                                        CharacterStatus
                                                                .statusListEnd[
                                                            characterModel
                                                                    .status! -
                                                                1]),
                                                  )
                                                : const SizedBox();
                                          },
                                        ),
                                      const SizedBox(height: 30),
                                      Center(
                                        child: Text(
                                          '$count/${charactersList.length}',
                                          style: TextStyle(
                                              fontSize: 48,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isMyRoleShown = !isMyRoleShown;
                                            });
                                          },
                                          icon: isMyRoleShown
                                              ? const Icon(Icons.hide_source)
                                              : const Icon(
                                                  Icons.remove_red_eye)),
                                      const SizedBox(height: 20),
                                      if (isMyRoleShown)
                                        Text(
                                            CharacterId.characterListEng[meInit
                                                    .myCharacter!.characterId! -
                                                1],
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary)),
                                    ],
                                  ),
                                ),
                                bottomNavigationBar: gameModel.isSleepTime ==
                                            false &&
                                        charactersList.any((e) =>
                                            e.name == meInit.myCharacter?.name &&
                                                e.isSleepModeOn == false ||
                                            e.name == meInit.myCharacter?.name &&
                                                e.isSleepModeOn == null)
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 80,
                                        child: AppButton(
                                          text: 'Sleep',
                                          onPressed: () async {
                                            setState(() {
                                              isLoadingSleepButton = true;
                                            });

                                            clearSelectionList();
                                            await RoomRepository.setSleepModeOn(
                                                roomId: widget.id,
                                                docId:
                                                    meInit.myCharacter!.docId!);
                                            stopTimer();
                                            isMafia = true;

                                            final response =
                                                await RoomRepository
                                                    .isAllCharactersSleepOn(
                                                        roomId: widget.id);

                                            // gameModel.isMafiaTime = true;
                                            // timerController.start();
                                            setState(() {
                                              isLoadingSleepButton = false;
                                            });
                                          },
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ))
                                    : charactersList.any((e) =>
                                            e.name == meInit.myCharacter?.name &&
                                            e.isSleepModeOn == true)
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            height: 80,
                                            child: TextTap(
                                              text: 'Awake',
                                              onPressed: () async {
                                                final response =
                                                    await RoomRepository
                                                        .setSleepModeOff(
                                                            roomId: widget.id,
                                                            docId: meInit
                                                                .myCharacter!
                                                                .docId!);
                                                gameModel.isMafiaTime = false;
                                                if (detectiveGuessedCharacter) {
                                                  screenPop(context);
                                                }
                                                detectiveGuessedCharacter =
                                                    false;

                                                stopTimer();
                                                setState(() {});
                                              },
                                            ))
                                        : const SizedBox());
                          } else {
                            return const SizedBox();
                          }
                        });
                  } else {
                    return Scaffold(
                      appBar: AppBar(),
                      body: const SizedBox(),
                    );
                  }
                }),
      ),
    );
  }
}
