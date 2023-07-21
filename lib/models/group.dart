import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  String id;
  String name;
  String imgUrl;
  List<String> membersUids;

  Group({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.membersUids,
  });

  factory Group.fromJson(Object? doc) =>
      _$GroupFromJson(doc as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}
