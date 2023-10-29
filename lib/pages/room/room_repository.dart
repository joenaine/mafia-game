import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';
import 'package:mafiagame/pages/create_game/model/game_model.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/pages/room/model/list_character_model.dart';
import 'package:mafiagame/services/string_extensions.dart';

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

  static Future<bool> getIsSleepTimeOff({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .get()
          .then((result) {
        GameModel gameModel = GameModel.fromFirestore(result);

        return gameModel.isSleepTime == false;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getIfSleepOn({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .get()
          .then((result) {
        GameModel gameModel = GameModel.fromFirestore(result);

        return gameModel.isSleepTime == true;
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

  static Future<bool> setSleepModeOn({
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
      if (characterModel.isSleepModeOn == false ||
          characterModel.isSleepModeOn == null) {
        return await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(CollectionName.characters)
            .doc(docId)
            .update({'isSleepModeOn': true}).then((value) => true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setSleepModeOff({
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
      if (characterModel.isSleepModeOn == true) {
        return await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(CollectionName.characters)
            .doc(docId)
            .update({'isSleepModeOn': false}).then((value) => true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isAllCharactersSleepOn({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .get()
          .then((value) {
        List<CharacterModel> charactersList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> category
            in value.docs) {
          charactersList.add(CharacterModel.fromFirestore(category));
        }
        int count = 0;
        int aliveStatus = 0;
        String? docId;
        for (int i = 0; i < charactersList.length; i++) {
          if (charactersList[i].isSleepModeOn == true &&
              charactersList[i].status != CharacterStatus.dead) {
            count++;
          }
          if (charactersList[i].status == CharacterStatus.muted) {
            docId = charactersList[i].docId;
          }
          if (charactersList[i].status != CharacterStatus.dead) {
            aliveStatus++;
          }
        }
        if (count == aliveStatus) {
          updateIsSleepTime(roomId: roomId, isSleepTime: true);
          if (docId != null) {
            setAliveCharacterStatus(roomId: roomId, docId: docId);
          }
        }
        return count == aliveStatus;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isAllCharactersSleepOff({
    required String roomId,
  }) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.characters)
          .get()
          .then((value) async {
        List<CharacterModel> charactersList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> category
            in value.docs) {
          charactersList.add(CharacterModel.fromFirestore(category));
        }
        int count = 0;
        int aliveStatus = 0;
        for (int i = 0; i < charactersList.length; i++) {
          if (charactersList[i].isSleepModeOn == false &&
              charactersList[i].status == CharacterStatus.alive) {
            count++;
          }
          if (charactersList[i].status == CharacterStatus.alive) {
            aliveStatus++;
          }
        }
        if (count == aliveStatus) {
          bool isSleepOn = await getIfSleepOn(roomId: roomId);
          if (isSleepOn) {
            await updateIsSleepTime(roomId: roomId, isSleepTime: false);
          }
        }
        return count == aliveStatus;
      });
    } catch (e) {
      return false;
    }
  }

  //FORM SELECTED CHARACTERS
  static Future<bool> sendSelectedCharacters({
    required String roomId,
    required String docId,
    required List<CharacterModel> selectedDoctorDocIds,
    required List<CharacterModel> selectedMafiaDocIds,
    required List<CharacterModel> selectedSilencerDocIds,
  }) async {
    try {
      const collectionName = 'selectedChars';
      DocumentSnapshot documentSnapshot = await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(collectionName)
          .doc(docId)
          .get();

      if (!documentSnapshot.exists) {
        return await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(collectionName)
            .doc(docId)
            .set({
          'doctorSelectionList': FieldValue.arrayUnion(
              selectedDoctorDocIds.map((e) => e.toJson()).toList()),
          'mafiaSelectionList': FieldValue.arrayUnion(
              selectedMafiaDocIds.map((e) => e.toJson()).toList()),
          'silencerSelectionList': FieldValue.arrayUnion(
              selectedSilencerDocIds.map((e) => e.toJson()).toList()),
        }).then((value) => true);
      }

      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(collectionName)
          .doc(docId)
          .update({
        'doctorSelectionList':
            selectedDoctorDocIds.map((e) => e.toJson()).toList(),
        'mafiaSelectionList':
            selectedMafiaDocIds.map((e) => e.toJson()).toList(),
        'silencerSelectionList':
            selectedSilencerDocIds.map((e) => e.toJson()).toList(),
      }).then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<String> getSelectedCharacters({
    required String roomId,
  }) async {
    try {
      const collectionName = 'selectedChars';
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(collectionName)
          .get()
          .then((value) async {
        List<ListCharacterModel> allSelectedCharactersList = [];
        for (QueryDocumentSnapshot<Map<String, dynamic>> category
            in value.docs) {
          allSelectedCharactersList
              .add(ListCharacterModel.fromFirestore(category));
        }
        List<CharacterModel> allMafiaList = [];
        List<CharacterModel> allDoctorList = [];
        List<CharacterModel> allSilencerList = [];
        for (var element in allSelectedCharactersList) {
          allMafiaList.addAll(element.mafiaSelectionList ?? []);
        }
        for (var element in allSelectedCharactersList) {
          allDoctorList.addAll(element.doctorSelectionList ?? []);
        }
        for (var element in allSelectedCharactersList) {
          allSilencerList.addAll(element.silencerSelectionList ?? []);
        }

        List<String> mafiaList =
            mergeDuplicatedNames(allMafiaList.map((e) => e.name!).toList());
        List<String> doctorList =
            mergeDuplicatedNames(allDoctorList.map((e) => e.name!).toList());
        List<String> silencerList =
            mergeDuplicatedNames(allSilencerList.map((e) => e.name!).toList());
        String mafiaSelected = 'unmatched';
        String doctorSelected = 'unmatched';
        String silencerSelected = 'unmatched';
        if (mafiaList.length == 1) {
          mafiaSelected = mafiaList.first;
          await RoomRepository.setDeadCharacterStatus(
              roomId: roomId, docId: allMafiaList.first.docId ?? '');
        }
        if (doctorList.length == 1) {
          doctorSelected = doctorList.first;
          await RoomRepository.setAliveCharacterStatus(
              roomId: roomId, docId: allDoctorList.first.docId ?? '');
        }
        if (silencerList.length == 1) {
          silencerSelected = silencerList.first;
          await RoomRepository.setMutedCharacterStatus(
              roomId: roomId, docId: allSilencerList.first.docId ?? '');
        }
        return 'Dead : $mafiaSelected \n Healed: $doctorSelected \n Muted: $silencerSelected';
      });
    } catch (e) {
      return '';
    }
  }

  static Future<bool> deleteCollectionSelectedChars(String roomId) async {
    try {
      QuerySnapshot documentSnapshot = await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection(CollectionName.selectedChars)
          .get();

      if (documentSnapshot.docs.isNotEmpty) {
        return await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(CollectionName.selectedChars)
            .get()
            .then((value) {
          for (DocumentSnapshot doc in value.docs) {
            doc.reference.delete();
          }
          return true;
        });
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteSelectedChars(String roomId) async {
    try {
      return await firestore
          .collection(CollectionName.rooms)
          .doc(roomId)
          .collection('selectedChars')
          .doc('1')
          .delete()
          .then((value) => true);
    } catch (e) {
      return false;
    }
  }

  static Future<bool> showResults(
      {required String roomId, required int length}) async {
    return await firestore
        .collection(CollectionName.rooms)
        .doc(roomId)
        .collection(CollectionName.selectedChars)
        .get()
        .then((value) {
      print('${value.docs.length} DOCS LENGTH');
      print('$length Alive LENGTH');
      return value.docs.length == length;
    });
  }

  static Future<bool> resetAllCharacters(
      {required String roomId, required int charlength}) async {
    try {
      for (int i = 1; i <= charlength; i++) {
        await firestore
            .collection(CollectionName.rooms)
            .doc(roomId)
            .collection(CollectionName.characters)
            .doc(i.toString())
            .update({'status': 1});
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
