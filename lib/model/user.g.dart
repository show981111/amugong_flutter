// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userID: json['userID'] as String,
    name: json['name'] as String,
    issuedAt: json['issuedAt'] as String,
    token: json['token'] as String,
    jwt: json['jwt'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userID,
      'name': instance.name,
      'issuedAt': instance.issuedAt,
      'token': instance.token,
      'jwt': instance.jwt,
    };
