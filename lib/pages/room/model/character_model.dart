import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mafiagame/services/types.dart';
part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  final String? docId;
  final int? characterId;
  final String? name;
  final int? status;
  final int? avatarIndex;
  final bool? isSleepModeOn;
  final List<CharacterModel>? voteList;

  CharacterModel(
      {this.characterId,
      this.status,
      this.name,
      this.docId,
      this.avatarIndex,
      this.isSleepModeOn,
      this.voteList});
  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  factory CharacterModel.fromFirestore(DocumentSnapshot<Json> doc) {
    return CharacterModel.fromJson(doc.data() ?? {});
  }

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);
}
