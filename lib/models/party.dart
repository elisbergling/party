import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'party.g.dart';

@JsonSerializable()
class Party {
  String id;
  String name;
  String about;
  int price;
  String imgUrl;
  Timestamp time;
  String hostName;
  String hostUid;
  List<String> comingUids;
  List<String> invitedUids;
  double? latitude;
  double? longitude;
  String? address;
  String country;
  String postalCode;

  Party({
    required this.id,
    required this.name,
    required this.about,
    required this.price,
    required this.imgUrl,
    required this.time,
    required this.hostName,
    required this.hostUid,
    required this.comingUids,
    required this.invitedUids,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.country,
    required this.postalCode,
  });

  factory Party.fromJson(Object? doc) =>
      _$PartyFromJson(doc as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$PartyToJson(this);
}
