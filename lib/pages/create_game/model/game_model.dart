import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mafiagame/services/types.dart';

part 'game_model.g.dart';

@JsonSerializable()
class GameModel {
  final String? roomId;
  final List<int>? charactersList;

  GameModel({this.roomId, this.charactersList});
  factory GameModel.fromJson(Map<String, dynamic> json) =>
      _$GameModelFromJson(json);

  factory GameModel.fromFirestore(DocumentSnapshot<Json> doc) {
    return GameModel.fromJson(doc.data() ?? {});
  }

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
