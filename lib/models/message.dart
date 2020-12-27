import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String id;
  final String message;
  final String uidFrom;
  final String uidTo;
  final Timestamp createdAt;

  Message({
    this.id,
    this.message,
    this.uidFrom,
    this.uidTo,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
