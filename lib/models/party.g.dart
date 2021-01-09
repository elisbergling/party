// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Party _$PartyFromJson(Map<String, dynamic> json) {
  return Party(
    id: json['id'] as String,
    name: json['name'] as String,
    about: json['about'] as String,
    price: json['price'] as int,
    imgUrl: json['imgUrl'] as String,
    time: json['time'] as Timestamp,
    hostName: json['hostName'] as String,
    hostUid: json['hostUid'] as String,
    comingUids: (json['comingUids'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PartyToJson(Party instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'about': instance.about,
      'price': instance.price,
      'imgUrl': instance.imgUrl,
      'time': instance.time,
      'hostName': instance.hostName,
      'hostUid': instance.hostUid,
      'comingUids': instance.comingUids,
    };
