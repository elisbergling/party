//import 'package:json_annotation/json_annotation.dart';

//part 'party.g.dart';

//@JsonSerializable()
class Party {
  Party({
    this.uid,
    this.name,
    this.about,
    this.imgUrl,
    this.coming,
  });

  String uid;
  String name;
  String about;
  String imgUrl;
  List<String> coming;

  //factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);
  //Map<String, dynamic> toJson() => _$PartyToJson(this);
}
