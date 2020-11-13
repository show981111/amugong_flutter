import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String userID;
  String name;
  String issuedAt;
  String token;
  String jwt;

  User({this.userID, this.name, this.issuedAt, this.token, this.jwt});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
