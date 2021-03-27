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
  double latitude;
  double longitude;
  String address;
  String country;
  String postalCode;

  Party({
    this.id,
    this.name,
    this.about,
    this.price,
    this.imgUrl,
    this.time,
    this.hostName,
    this.hostUid,
    this.comingUids,
    this.invitedUids,
    this.latitude,
    this.longitude,
    this.address,
    this.country,
    this.postalCode,
  });

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);
  Map<String, dynamic> toJson() => _$PartyToJson(this);
}
