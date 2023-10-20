import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mafiagame/services/types.dart';

import 'character_model.dart';
part 'list_character_model.g.dart';

@JsonSerializable()
class ListCharacterModel {
  final List<CharacterModel>? doctorSelectionList;
  final List<CharacterModel>? mafiaSelectionList;
  final List<CharacterModel>? silencerSelectionList;

  ListCharacterModel(
      {this.doctorSelectionList,
      this.mafiaSelectionList,
      this.silencerSelectionList});
  factory ListCharacterModel.fromJson(Map<String, dynamic> json) =>
      _$ListCharacterModelFromJson(json);

  factory ListCharacterModel.fromFirestore(DocumentSnapshot<Json> doc) {
    return ListCharacterModel.fromJson(doc.data() ?? {});
  }

  Map<String, dynamic> toJson() => _$ListCharacterModelToJson(this);
}
