// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    uid: json['uid'] as String,
    name: json['name'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    imgUrl: json['imgUrl'] as String,
    friendUids: (json['friendUids'] as List)?.map((e) => e as String)?.toList(),
    requestUids:
        (json['requestUids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'imgUrl': instance.imgUrl,
      'friendUids': instance.friendUids,
      'requestUids': instance.requestUids,
    };
