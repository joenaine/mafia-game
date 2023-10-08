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
import 'package:mafiagame/constants/screen_navigation_const.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/join_game/join_game_provider.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/pages/room/room_repository.dart';
import 'package:mafiagame/services/string_extensions.dart';
import 'package:mafiagame/widgets/alert_dialog.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_global_loader_widget.dart';
import 'package:mafiagame/widgets/app_overlay_widget.dart';
import 'package:mafiagame/widgets/nav_back.dart';
import 'package:mafiagame/widgets/text_tap.dart';
import 'package:provider/provider.dart';

class RoomMainScreenOffline extends StatefulWidget {
  const RoomMainScreenOffline({super.key, required this.id, this.name});
  final String id;
  final String? name;

  @override
  State<RoomMainScreenOffline> createState() => _RoomMainScreenOfflineState();
}

class _RoomMainScreenOfflineState extends State<RoomMainScreenOffline>
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
  void dispose() {
    timerController.dispose();
    // _timer.cancel();

    super.dispose();
  }

  // late Timer _timer;
  final int _start = 59;
  bool isTimerFinished = false;

  void startTimer(int value) {
    // isTimerFinished = false;
    // _start = value;
    // const oneSec = Duration(seconds: 1);
    // _timer = Timer.periodic(
    //   oneSec,
    //   (Timer timer) {
    //     if (_start == 0) {
    //       setState(() {
    //         timer.cancel();
    //         isTimerFinished = true;
    //       });
    //     } else {
    //       setState(() {
    //         _start--;
    //       });
    //     }
    //   },
    // );
  }

  void stopTimer() {
    timerController.stop();
    // timerController.start();
    timerController.reset();

    // _timer.cancel();
    selectedMafiaCharactersList.clear();
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

  Future<void> mafiaOption() async {
    if (selectedMafiaCharactersList.isNotEmpty) {
      for (int i = 0; i < selectedMafiaCharactersList.length; i++) {
        await RoomRepository.setDeadCharacterStatus(
            roomId: widget.id,
            docId: selectedMafiaCharactersList[i].docId ?? '');
      }
    }
  }

  Future<void> doctorOption() async {
    if (selectedDoctorCharactersList.isNotEmpty) {
      for (int i = 0; i < selectedDoctorCharactersList.length; i++) {
        await RoomRepository.setAliveCharacterStatus(
            roomId: widget.id,
            docId: selectedDoctorCharactersList[i].docId ?? '');
      }
    }
  }

  Future<void> silencerOption() async {
    if (selectedSilencerCharactersList.isNotEmpty) {
      for (int i = 0; i < selectedSilencerCharactersList.length; i++) {
        await RoomRepository.setMutedCharacterStatus(
            roomId: widget.id,
            docId: selectedSilencerCharactersList[i].docId ?? '');
      }
    }
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

  bool isLoading = false;
  GameModel gameModel = GameModel(
      isDetectiveTime: false,
      isDoctorTime: false,
      isMafiaTime: false,
      isSilencerTime: false,
      isTimeController: false,
      isSleepTime: false);

  Future<void> getMafiaTime() async {
    gameModel.isMafiaTime =
        await RoomRepository.getIfMafiaValue(roomId: widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final meInit = Provider.of<JoinGameProvider>(context);
    return AppOverlayLoadingWidget(
      isLoading: isLoading,
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
                    gameModel.isSleepTime = gameModelRaw.isSleepTime;
                    gameModel.createdBy = gameModelRaw.createdBy;
                    gameModel.timerInSec = gameModelRaw.timerInSec;

                    // gameModel.isDoctorTime = false;
                    // gameModel.isSilencerTime = false;
                    // gameModel.isDetectiveTime = false;
                    // gameModel.isTimeController = false;

                    return Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      appBar: AppBar(
                        leading: NavBack(
                          onWillPop: () {
                            // stopTimer();
                          },
                        ),
                        title: Text(gameModelRaw.roomId ?? ''),
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
                              for (QueryDocumentSnapshot<
                                      Map<String, dynamic>> category
                                  in snapshot.data!.docs) {
                                charactersList.add(
                                    CharacterModel.fromFirestore(category));
                              }
                              int count = 0;
                              for (var i = 0; i < charactersList.length; i++) {
                                if (charactersList[i].name != null &&
                                    charactersList[i].status == 1) {
                                  count++;
                                  if (charactersList[i].name == widget.name) {
                                    meInit.myCharacter = charactersList[i];
                                  }
                                }
                              }

                              if (gameModel.isSleepTime == true) {
                                // startTimer(gameModel.timerInSec ?? 10);
                                // timerController.stop();
                                // timerController.reset();
                                timerController.start();
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (gameModel.isSleepTime == true) ...[
                                      if (gameModel.isMafiaTime == true) ...[
                                        Center(
                                            child: LinearTimer(
                                                onTimerEnd: () {
                                                  print(
                                                      '${gameModel.isMafiaTime} BOOL First');
                                                  gameModel.isMafiaTime = false;
                                                  print(
                                                      '${gameModel.isMafiaTime} BOOL');
                                                  // if (gameModel.createdBy ==
                                                  //     meInit
                                                  //         .myCharacter?.name) {
                                                  //   await RoomRepository
                                                  //           .updateIsMafiaTime(
                                                  //               roomId:
                                                  //                   widget.id,
                                                  //               isMafiaTime:
                                                  //                   false)
                                                  //       .then((value) async {});
                                                  // }

                                                  gameModel.isDoctorTime = true;

                                                  timerController.reset();
                                                  timerController.start();
                                                  // setState(() {});
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    AppColors.white,
                                                color: AppColors.error,
                                                controller: timerController,
                                                duration: Duration(
                                                    seconds:
                                                        gameModel.timerInSec ??
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
                                          style: AppStyles.s24w500
                                              .copyWith(color: AppColors.white),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          children: charactersList
                                              .map((character) => Column(
                                                    children: [
                                                      if (character.name !=
                                                              null &&
                                                          character.status ==
                                                              1) ...[
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
                                                                      border: selectedMafiaCharactersList.any((element) =>
                                                                              element.name ==
                                                                              character
                                                                                  .name)
                                                                          ? Border.all(
                                                                              strokeAlign: StrokeAlign.outside,
                                                                              width: 2,
                                                                              color: AppColors.error)
                                                                          : const Border()),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                    height: 60,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(ShortText
                                                                  .fromText(
                                                                      character
                                                                              .name ??
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
                                                onTimerEnd: () {
                                                  print(
                                                      '${gameModel.isMafiaTime} BOOL Third');
                                                  gameModel.isDoctorTime =
                                                      false;
                                                  gameModel.isSilencerTime =
                                                      true;

                                                  timerController.reset();
                                                  timerController.start();
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    AppColors.white,
                                                color: AppColors.error,
                                                controller: timerController,
                                                duration: Duration(
                                                    seconds:
                                                        gameModel.timerInSec ??
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
                                          style: AppStyles.s24w500
                                              .copyWith(color: AppColors.white),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          children: charactersList
                                              .map((character) => Column(
                                                    children: [
                                                      if (character.name !=
                                                              null &&
                                                          character.status ==
                                                              1) ...[
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
                                                                      border: selectedDoctorCharactersList.any((element) =>
                                                                              element.name ==
                                                                              character
                                                                                  .name)
                                                                          ? Border.all(
                                                                              strokeAlign: StrokeAlign.outside,
                                                                              width: 2,
                                                                              color: AppColors.error)
                                                                          : const Border()),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                    height: 60,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(ShortText
                                                                  .fromText(
                                                                      character
                                                                              .name ??
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
                                      if (gameModel.isSilencerTime == true) ...[
                                        Center(
                                            child: LinearTimer(
                                                onTimerEnd: () {
                                                  gameModel.isSilencerTime =
                                                      false;
                                                  gameModel.isDetectiveTime =
                                                      true;

                                                  timerController.reset();
                                                  timerController.start();
                                                  setState(() {});
                                                },
                                                backgroundColor:
                                                    AppColors.white,
                                                color: AppColors.error,
                                                controller: timerController,
                                                duration: Duration(
                                                    seconds:
                                                        gameModel.timerInSec ??
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
                                          style: AppStyles.s24w500
                                              .copyWith(color: AppColors.white),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          children: charactersList
                                              .map((character) => Column(
                                                    children: [
                                                      if (character.name !=
                                                              null &&
                                                          character.status ==
                                                              1) ...[
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
                                                                      border: selectedSilencerCharactersList.any((element) =>
                                                                              element.name ==
                                                                              character
                                                                                  .name)
                                                                          ? Border.all(
                                                                              strokeAlign: StrokeAlign.outside,
                                                                              width: 2,
                                                                              color: AppColors.error)
                                                                          : const Border()),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                    height: 60,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(ShortText
                                                                  .fromText(
                                                                      character
                                                                              .name ??
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
                                                  // timerController.stop();
                                                  timerController.reset();

                                                  gameModel.isDetectiveTime =
                                                      false;
                                                  setState(() {});
                                                  if (gameModel.createdBy ==
                                                      meInit
                                                          .myCharacter?.name) {
                                                    final response =
                                                        await RoomRepository
                                                            .updateIsSleepTime(
                                                                roomId:
                                                                    widget.id,
                                                                isSleepTime:
                                                                    false);
                                                  }

                                                  // setState(() {});
                                                },
                                                backgroundColor:
                                                    AppColors.white,
                                                color: AppColors.error,
                                                controller: timerController,
                                                duration: Duration(
                                                    seconds:
                                                        gameModel.timerInSec ??
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
                                          style: AppStyles.s24w500
                                              .copyWith(color: AppColors.white),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          children: charactersList
                                              .map((character) => Column(
                                                    children: [
                                                      if (character.name !=
                                                              null &&
                                                          character.status ==
                                                              1) ...[
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
                                                                      border: selectedSilencerCharactersList.any((element) =>
                                                                              element.name ==
                                                                              character
                                                                                  .name)
                                                                          ? Border.all(
                                                                              strokeAlign: StrokeAlign.outside,
                                                                              width: 2,
                                                                              color: AppColors.error)
                                                                          : const Border()),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    '${AppAssets.avatar.icon}${character.avatarIndex!}.svg',
                                                                    height: 60,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Text(ShortText
                                                                  .fromText(
                                                                      character
                                                                              .name ??
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                                                        style: const TextStyle(
                                                            fontSize: 30),
                                                      ),
                                                      const SizedBox(width: 10),
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
                                                        )
                                                    ],
                                                  ),
                                                  trailing: Text(CharacterStatus
                                                          .statusListEnd[
                                                      characterModel.status! -
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
                                  ],
                                ),
                              );
                            } else {
                              return AppLoaderWidget();
                            }
                          }),
                      bottomNavigationBar: gameModel.isSleepTime == false &&
                              gameModel.createdBy == meInit.myCharacter?.name
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              height: 80,
                              child: AppButton(
                                text: 'Sleep',
                                onPressed: () async {
                                  final response =
                                      await RoomRepository.updateIsSleepTime(
                                          roomId: widget.id, isSleepTime: true);
                                  if (gameModel.createdBy ==
                                      meInit.myCharacter?.name) {
                                    await RoomRepository.updateIsMafiaTime(
                                        roomId: widget.id, isMafiaTime: true);
                                    await RoomRepository.updateIsTimeController(
                                        roomId: widget.id,
                                        isTimeController: true);
                                  }
                                  // gameModel.isMafiaTime = true;
                                  gameModel.isTimeController = true;
                                  await getMafiaTime();
                                  setState(() {});

                                  // await RoomRepository.updateIsTimeController(
                                  //     roomId: widget.id,
                                  //     isTimeController: true);

                                  if (response) {}
                                },
                                color: Theme.of(context).colorScheme.primary,
                              ))
                          : gameModel.createdBy == meInit.myCharacter?.name
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  height: 80,
                                  child: TextTap(
                                    text: 'Stop timer',
                                    onPressed: () async {
                                      final response = await RoomRepository
                                          .updateIsSleepTime(
                                              roomId: widget.id,
                                              isSleepTime: false);
                                      gameModel.isSleepTime = false;
                                      if (detectiveGuessedCharacter) {
                                        screenPop(context);
                                      }
                                      detectiveGuessedCharacter = false;
                                      gameModel.isMafiaTime = false;
                                      gameModel.isDoctorTime = false;
                                      gameModel.isSilencerTime = false;
                                      gameModel.isDetectiveTime = false;
                                      gameModel.isTimeController = false;
                                      setState(() {});

                                      // await RoomRepository
                                      //     .updateIsTimeController(
                                      //         roomId: widget.id,
                                      //         isTimeController: false);

                                      if (response) {
                                        stopTimer();
                                      }
                                    },
                                  ))
                              : const SizedBox(),
                    );
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
