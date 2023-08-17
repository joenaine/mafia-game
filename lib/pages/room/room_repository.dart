import 'package:mafiagame/constants/app_variables_const.dart';
import 'package:mafiagame/constants/firebase_consts.dart';

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
}
