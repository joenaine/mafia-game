// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      characterId: json['characterId'] as int?,
      status: json['status'] as int?,
      name: json['name'] as String?,
      docId: json['docId'] as String?,
      avatarIndex: json['avatarIndex'] as int?,
      isSleepModeOn: json['isSleepModeOn'] as bool?,
      voteList: (json['voteList'] as List<dynamic>?)
          ?.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'docId': instance.docId,
      'characterId': instance.characterId,
      'name': instance.name,
      'status': instance.status,
      'avatarIndex': instance.avatarIndex,
      'isSleepModeOn': instance.isSleepModeOn,
      'voteList': instance.voteList,
    };
