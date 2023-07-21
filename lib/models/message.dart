import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String message;
  final Timestamp createdAt;
  final String? id;
  final String? uidFrom;
  final String? uidTo;

  Message({
    required this.createdAt,
    required this.message,
    this.id,
    this.uidFrom,
    this.uidTo,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
