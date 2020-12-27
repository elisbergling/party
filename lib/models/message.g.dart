// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['id'] as String,
    message: json['message'] as String,
    uidFrom: json['uidFrom'] as String,
    uidTo: json['uidTo'] as String,
    createdAt: json['createdAt'] as Timestamp,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'uidFrom': instance.uidFrom,
      'uidTo': instance.uidTo,
      'createdAt': instance.createdAt,
    };
