import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';

class GameRepository {
  static Future<bool> createGame(
      {required GameModel g,
      required String name,
      required int avatarIndex}) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(g.roomId)
          .set({'roomId': g.roomId}).then((value) async {
        for (int i = 0; i < g.charactersList!.length; i++) {
          await firestore
              .collection(CollectionName.rooms)
              .doc(g.roomId)
              .collection(CollectionName.characters)
              .doc('${i + 1}')
              .set({'docId': '${i + 1}', 'characterId': g.charactersList?[i]});
        }
        await joinCharacterGame(
            roomId: g.roomId!, name: name, avatarIndex: avatarIndex);
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> joinCharacterGame(
      {required String roomId,
      required String name,
      required int avatarIndex}) async {
    try {
      DocumentReference docRef =
          firestore.collection(CollectionName.rooms).doc(roomId);

      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        List<CharacterModel> charactersList =
            await getCharacterList(roomId: roomId) ?? [];
        for (int i = 0; i < charactersList.length; i++) {
          if (charactersList[i].name == null) {
            return await setCharacter(
                    roomId: roomId,
                    docId: charactersList[i].docId!,
                    characterModel:
                        CharacterModel(name: name, avatarIndex: avatarIndex))!
                .then((value) {
              return true;
            });
          } else if (charactersList[i].name == name) {
            return true;
          }
        }
      } else {
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool>? setCharacter(
      {required String roomId,
      required String docId,
      required CharacterModel characterModel}) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .doc(docId)
          .update({
        'name': characterModel.name,
        'status': CharacterStatus.alive,
        'avatarIndex': characterModel.avatarIndex
      }).then((response) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<CharacterModel>? getCharacterDoc(
      {required String roomId, required String docId}) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .doc(docId)
          .get()
          .then((response) {
        CharacterModel characterModel = CharacterModel.fromFirestore(response);
        return characterModel;
      });
    } catch (e) {
      return CharacterModel();
    }
  }

  static Future<List<CharacterModel>>? getCharacterList(
      {required String roomId}) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .get()
          .then((response) {
        List<CharacterModel> charactersList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> category
            in response.docs) {
          charactersList.add(CharacterModel.fromFirestore(category));
        }
        return charactersList;
      });
    } catch (e) {
      return [];
    }
  }
}
