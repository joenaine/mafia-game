import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/app_colors_const.dart';
import 'package:mafiagame/constants/screen_navigation_const.dart';
import 'package:mafiagame/pages/create_game/create_game_repository.dart';
import 'package:mafiagame/pages/join_game/join_game_provider.dart';
import 'package:mafiagame/pages/room/room_main_screen.dart';
import 'package:mafiagame/pages/room/room_repository.dart';
import 'package:mafiagame/widgets/alert_dialog.dart';
import 'package:mafiagame/widgets/app_button.dart';
import 'package:mafiagame/widgets/app_hide_keyboard_widget.dart';
import 'package:mafiagame/widgets/app_overlay_widget.dart';
import 'package:mafiagame/widgets/custom_textfield_widget.dart';
import 'package:mafiagame/widgets/pinput_textfield.dart';
import 'package:provider/provider.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final List<TextEditingController> _roomIdControllerList =
      List.generate(5, (index) => TextEditingController());
  final TextEditingController _nameController = TextEditingController();
  final List<FocusNode> _focusNodeList =
      List.generate(5, (index) => FocusNode());

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final joinGameInit = Provider.of<JoinGameProvider>(context);
    return AppHideKeyBoardWidget(
      child: AppOverlayLoadingWidget(
        isLoading: isLoading,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _roomIdControllerList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        // FocusNode? focusNode =
                        //     index != _roomIdControllerList.length - 1
                        //         ? _focusNodeList[number]
                        //         : _roomIdControllerList.length - 2;
                        return PinputTextfield(
                          focusNode: _focusNodeList[index],
                          onChanged: (p0) {
                            if (index == _roomIdControllerList.length - 1) {
                              FocusScope.of(context).unfocus();
                            }
                            if (p0.isNotEmpty &&
                                index != _roomIdControllerList.length - 1) {
                              _focusNodeList[index + 1].requestFocus();
                            }
                          },
                          controller: _roomIdControllerList[index],
                          hintText: 'room id',
                          keyboardType: TextInputType.number,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextfield(
                    controller: _nameController,
                    hintText: 'nickname',
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      for (int i = 1; i < 17; i++)
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                joinGameInit.setCheckbox(i);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 16, right: 16.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: joinGameInit
                                                    .selectedContainerIndex ==
                                                i
                                            ? AppColors.error
                                            : Colors.white)),
                                child: SvgPicture.asset(
                                  '${AppAssets.avatar.icon}$i.svg',
                                  height: 40,
                                ),
                              ),
                            ),
                            joinGameInit.selectedContainerIndex == i
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
                      setState(() {
                        isLoading = true;
                      });
                      var concatenate = StringBuffer();
                      for (var item in _roomIdControllerList) {
                        concatenate.write(item.text);
                      }
                      final response = await GameRepository.joinCharacterGame(
                          roomId: concatenate.toString(),
                          name: _nameController.text.trim(),
                          avatarIndex: joinGameInit.selectedContainerIndex);
                      if (response) {
                        setState(() {
                          isLoading = false;
                        });
                        bool isTimerRunning =
                            await RoomRepository.getIfGameStarted(
                                roomId: concatenate.toString());
                        isTimerRunning
                            ? AlertDialogCustom.customAlert(
                                context,
                                title: 'The Game is\nin Sleep Mode',
                                content: null,
                                generalButton: 'generalButton',
                                onTapGeneral: () {
                                  screenPop(context);
                                },
                              )
                            : changeScreen(
                                context,
                                RoomMainScreen(
                                  id: concatenate.toString(),
                                  name:
                                      _nameController.text.trim().toLowerCase(),
                                ));
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    text: 'JOIN',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
