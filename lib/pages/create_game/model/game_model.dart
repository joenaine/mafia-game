import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mafiagame/pages/room/model/character_model.dart';
import 'package:mafiagame/services/types.dart';

part 'game_model.g.dart';

@JsonSerializable()
class GameModel {
  final String? roomId;
  final List<int>? charactersList;
  int? timerInSec;
  bool? isSleepTime;
  bool? isMafiaTime;
  bool? isDoctorTime;
  bool? isDetectiveTime;
  bool? isSilencerTime;
  bool? isTimeController;
  String? createdBy;
  List<CharacterModel>? doctorSelectionList;
  List<CharacterModel>? mafiaSelectionList;
  List<CharacterModel>? silencerSelectionList;

  GameModel(
      {this.isTimeController,
      this.isMafiaTime,
      this.isDoctorTime,
      this.isDetectiveTime,
      this.isSilencerTime,
      this.roomId,
      this.charactersList,
      this.timerInSec,
      this.isSleepTime,
      this.createdBy,
      this.doctorSelectionList,
      this.mafiaSelectionList,
      this.silencerSelectionList});
  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  factory GameModel.fromFirestore(DocumentSnapshot<Json> doc) {
    return GameModel.fromJson(doc.data() ?? {});
  }

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
