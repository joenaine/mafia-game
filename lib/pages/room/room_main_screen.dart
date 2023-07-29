import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mafiagame/constants/app_assets.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/widgets/app_global_loader_widget.dart';
import 'package:mafiagame/widgets/nav_back.dart';

class RoomMainScreen extends StatefulWidget {
  const RoomMainScreen({super.key, required this.id});
  final String id;

  @override
  State<RoomMainScreen> createState() => _RoomMainScreenState();
}

class _RoomMainScreenState extends State<RoomMainScreen> {
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
                            ListView.builder(
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
                                              style:
                                                  const TextStyle(fontSize: 30),
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
                            )
                          ],
                        ),
                      );
                    } else {
                      return AppLoaderWidget();
                    }
                  }),
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
