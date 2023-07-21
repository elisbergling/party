import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend {
  Friend({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.imgUrl,
    required this.friendUids,
    required this.requestUids,
  });

  Friend.empty({
    required this.name,
    this.uid = '',
    this.username = '',
    this.email = '',
    this.imgUrl = '',
    this.friendUids = const [],
    this.requestUids = const [],
  });

  String uid;
  String name;
  String username;
  String email;
  String imgUrl;
  List<String> friendUids;
  List<String> requestUids;

  factory Friend.fromJson(Object? doc) =>
      _$FriendFromJson(doc as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
