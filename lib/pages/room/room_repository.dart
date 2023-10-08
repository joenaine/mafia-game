import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';

class RoomRepository {
  static Future<bool> getIfGameStarted({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .get()
          .then((result) {
        GameModel gameModel = GameModel.fromFirestore(result);

        return gameModel.isSleepTime ?? false ? true : false;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getIfGameAdmin({
    required String roomId,
    required String name,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .get()
          .then((result) {
        GameModel gameModel = GameModel.fromFirestore(result);

        return gameModel.createdBy == name;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getIfMafiaValue({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .get()
          .then((result) {
        GameModel gameModel = GameModel.fromFirestore(result);

        return gameModel.isMafiaTime ?? false;
      });
    } catch (e) {
      return false;
    }
  }

  //Timer controller
  static Future<bool> updateAllTime({
    required String roomId,
    required bool isValue,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({
        'isTimeController': isValue,
        'isSleepTime': isValue,
        // 'isMafiaTime': isValue,
        // 'isDoctorTime': isValue,
        // 'isSilencerTime': isValue,
        // 'isDetectiveTime': isValue,
      }).then((value) => true);
    } catch (e) {
      return false;
    }
  }

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

//MAFIA TIME
  static Future<bool> updateIsMafiaTime({
    required String roomId,
    required bool isMafiaTime,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isMafiaTime': isMafiaTime}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  //DOCTOR TIME
  static Future<bool> updateIsDoctorTime({
    required String roomId,
    required bool isDoctorTime,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isDoctorTime': isDoctorTime}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  //SILENCER TIME
  static Future<bool> updateIsSilencerTime({
    required String roomId,
    required bool isSilencerTime,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isSilencerTime': isSilencerTime}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  //DETECTIVE TIME
  static Future<bool> updateIsDetectiveTime({
    required String roomId,
    required bool isDetectiveTime,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isDetectiveTime': isDetectiveTime}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  //Timer controller
  static Future<bool> updateIsTimeController({
    required String roomId,
    required bool isTimeController,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'isTimeController': isTimeController}).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateStateCounter({
    required String roomId,
    required int updatedStateCount,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .update({'updatedStateCount': updatedStateCount}).then(
              (value) => true);
    } catch (e) {
      return false;
    }
  }

//Set Character Dead Status
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
