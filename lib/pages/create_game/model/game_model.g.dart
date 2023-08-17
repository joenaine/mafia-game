// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      roomId: json['roomId'] as String?,
      charactersList: (json['charactersList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      timerInSec: json['timerInSec'] as int?,
      isSleepTime: json['isSleepTime'] as bool?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'charactersList': instance.charactersList,
      'timerInSec': instance.timerInSec,
      'isSleepTime': instance.isSleepTime,
    };
