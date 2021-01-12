import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  String id;
  String name;
  String imgUrl;
  List<String> membersUids;

  Group({
    this.id,
    this.name,
    this.imgUrl,
    this.membersUids,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
