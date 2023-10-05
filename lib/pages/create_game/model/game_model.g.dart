// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      isTimeController: json['isTimeController'] as bool?,
      isMafiaTime: json['isMafiaTime'] as bool?,
      isDoctorTime: json['isDoctorTime'] as bool?,
      isDetectiveTime: json['isDetectiveTime'] as bool?,
      isSilencerTime: json['isSilencerTime'] as bool?,
      roomId: json['roomId'] as String?,
      charactersList: (json['charactersList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      timerInSec: json['timerInSec'] as int?,
      isSleepTime: json['isSleepTime'] as bool?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'charactersList': instance.charactersList,
      'timerInSec': instance.timerInSec,
      'isSleepTime': instance.isSleepTime,
      'isMafiaTime': instance.isMafiaTime,
      'isDoctorTime': instance.isDoctorTime,
      'isDetectiveTime': instance.isDetectiveTime,
      'isSilencerTime': instance.isSilencerTime,
      'isTimeController': instance.isTimeController,
      'createdBy': instance.createdBy,
    };
