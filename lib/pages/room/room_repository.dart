import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';

class RoomRepository {
  static Future<bool> updateIsSleepTime({
    required String roomId,
    required bool isSleepTime,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isSleepTime': isSleepTime}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setDeadCharacterStatus({
    required String roomId,
    required String docId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .doc(docId)
          .update({'status': 2}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setAliveCharacterStatus({
    required String roomId,
    required String docId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .doc(docId)
          .update({'status': 1}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setMutedCharacterStatus({
    required String roomId,
    required String docId,
  }) async {
    try {
      CharacterModel characterModel = await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .doc(docId)
          .get()
          .then((value) => CharacterModel.fromFirestore(value));
      if (characterModel.status != 2) {
        return await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(CollectionName.characters)
            .doc(docId)
            .update({'status': 3}).then((value) => true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
