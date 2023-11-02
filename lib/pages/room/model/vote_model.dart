import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mafiagame/services/types.dart';
part 'vote_model.g.dart';

@JsonSerializable()
class VoteModel {
  final int? count;
  final String? docId;

  VoteModel({this.docId, this.count});
  factory VoteModel.fromJson(Map<String, dynamic> json) =>
      _$VoteModelFromJson(json);

  factory VoteModel.fromFirestore(DocumentSnapshot<Json> doc) {
    return VoteModel.fromJson(doc.data() ?? {});
  }

  Map<String, dynamic> toJson() => _$VoteModelToJson(this);
}
