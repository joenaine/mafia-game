// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteModel _$VoteModelFromJson(Map<String, dynamic> json) => VoteModel(
      docId: json['docId'] as String?,
      count: json['count'] as int?,
    );

Map<String, dynamic> _$VoteModelToJson(VoteModel instance) => <String, dynamic>{
      'count': instance.count,
      'docId': instance.docId,
    };
