// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_character_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListCharacterModel _$ListCharacterModelFromJson(Map<String, dynamic> json) =>
    ListCharacterModel(
      doctorSelectionList: (json['doctorSelectionList'] as List<dynamic>?)
          ?.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mafiaSelectionList: (json['mafiaSelectionList'] as List<dynamic>?)
          ?.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      silencerSelectionList: (json['silencerSelectionList'] as List<dynamic>?)
          ?.map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListCharacterModelToJson(ListCharacterModel instance) =>
    <String, dynamic>{
      'doctorSelectionList': instance.doctorSelectionList,
      'mafiaSelectionList': instance.mafiaSelectionList,
      'silencerSelectionList': instance.silencerSelectionList,
    };
