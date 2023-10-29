import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/screen_navigation_const.dart';
import 'package:mafiagame/pages/create_game/create_game_provider.dart';
import 'package:mafiagame/pages/create_game/create_game_repository.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/room_mafia_screen.dart';
import 'package:mafiagame/services/uui_generator.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_hide_keyboard_widget.dart';
import 'package:mafiagame/widgets/app_overlay_widget.dart';
import 'package:mafiagame/widgets/character_counter_widget.dart';
import 'package:mafiagame/widgets/custom_textfield_widget.dart';
import 'package:provider/provider.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _nicknameController.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme;
    final gameInit = Provider.of<CreateGameProvider>(context);
    return AppHideKeyBoardWidget(
      child: AppOverlayLoadingWidget(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(),
          body: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CharacterCounterWidget(
                        character: 'Civil',
                        count: gameInit.civil,
                        increment: () => gameInit.civilIncrement(),
                        decrement: () => gameInit.civilDecrement(),
                      ),
                      CharacterCounterWidget(
                        character: 'Mafia',
                        count: gameInit.mafia,
                        increment: () => gameInit.mafiaIncrement(),
                        decrement: () => gameInit.mafiaDecrement(),
                      ),
                      CharacterCounterWidget(
                        character: 'Doctor',
                        count: gameInit.doctor,
                        increment: () => gameInit.doctorIncrement(),
                        decrement: () => gameInit.doctorDecrement(),
                      ),
                      CharacterCounterWidget(
                        character: 'Detective',
                        count: gameInit.detective,
                        increment: () => gameInit.detectiveIncrement(),
                        decrement: () => gameInit.detectiveDecrement(),
                      ),
                      CharacterCounterWidget(
                        character: 'Silencer',
                        count: gameInit.silencer,
                        increment: () => gameInit.silencerIncrement(),
                        decrement: () => gameInit.silencerDecrement(),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Night time timer (in sec)',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        color: appColor.primary,
                        thickness: 4,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => gameInit.remove20(),
                            child: Text(
                              '-20',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => gameInit.remove10(),
                            child: Text(
                              '-10',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => gameInit.remove5(),
                            child: Text(
                              '-5',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                          Text(
                            gameInit.timeCount.toString(),
                            style: const TextStyle(fontSize: 60),
                          ),
                          GestureDetector(
                            onTap: () => gameInit.add5(),
                            child: Text(
                              '+5',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => gameInit.add10(),
                            child: Text(
                              '+10',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => gameInit.add20(),
                            child: Text(
                              '+20',
                              style: TextStyle(
                                  fontSize: 24, color: appColor.secondary),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: appColor.primary,
                        thickness: 4,
                      ),
                      const SizedBox(height: 30),
                      CustomTextfield(
                        controller: _nicknameController,
                        hintText: 'Nickname',
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (int i = 1; i < 17; i++)
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    gameInit.setCheckbox(i);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 16, right: 16.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color:
                                                gameInit.selectedContainerIndex ==
                                                        i
                                                    ? AppColors.error
                                                    : Colors.white)),
                                    child: SvgPicture.asset(
                                      '${AppAssets.avatar.icon}$i.svg',
                                      height: 40,
                                    ),
                                  ),
                                ),
                                gameInit.selectedContainerIndex == i
                                    ? const Positioned(
                                        top: 14,
                                        right: 17,
                                        child: Icon(
                                          Icons.check_box,
                                          size: 14,
                                          color: AppColors.error,
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            )
                        ],
                      ),
                      const SizedBox(height: 40),
                      AppButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String id = UUIDGenerator().id5Char();

                            List<int> charactersList = [];

                            for (var i = 0; i < gameInit.civil; i++) {
                              charactersList.add(CharacterId.civilian);
                            }
                            for (var i = 0; i < gameInit.mafia; i++) {
                              charactersList.add(CharacterId.mafia);
                            }
                            for (var i = 0; i < gameInit.doctor; i++) {
                              charactersList.add(CharacterId.doctor);
                            }
                            for (var i = 0; i < gameInit.detective; i++) {
                              charactersList.add(CharacterId.detective);
                            }
                            for (var i = 0; i < gameInit.silencer; i++) {
                              charactersList.add(CharacterId.silencer);
                            }
                            charactersList.shuffle();
                            GameModel g = GameModel(
                                roomId: id,
                                charactersList: charactersList,
                                timerInSec: gameInit.timeCount,
                                isSleepTime: false);
                            setState(() {
                              isLoading = true;
                            });
                            final response = await GameRepository.createGame(
                                g: g,
                                name: _nicknameController.text
                                    .trim()
                                    .toLowerCase(),
                                avatarIndex: gameInit.selectedContainerIndex);
                            if (response) {
                              setState(() {
                                isLoading = false;
                              });
                              changeScreen(
                                  context,
                                  RoomMafiaScreen(
                                    id: g.roomId!,
                                    name: _nicknameController.text
                                        .trim()
                                        .toLowerCase(),
                                  ));
                            }
                          }
                        },
                        text: 'Create room',
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
