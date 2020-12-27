import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend {
  Friend({
    this.uid,
    this.name,
    this.username,
    this.email,
    this.imgUrl,
    this.friendUids,
  });

  String uid;
  String name;
  String username;
  String email;
  String imgUrl;
  List<String> friendUids;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
