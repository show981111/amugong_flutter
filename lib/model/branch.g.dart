// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) {
  List<BusinessHour> bhList = new List<BusinessHour>();
  json['businessHour'].forEach((v) {
    bhList.add(new BusinessHour.fromJson(v));
  });
  return Branch(
    address: json['address'] as String,
    branchID: json['branchID'] as int,
    branchIntro: json['branchIntro'] as String,
    branchName: json['branchName'] as String,
    curNum: json['curNum'] as int,
    lat: json['lat'] as double,
    lng: json['lng'] as double,
    totalSeat: json['totalSeat'] as int,
    businessHour: bhList,
    atmosphere: json['atmosphere'] as String,
    music: json['music'] as String,
    light: json['light'] as String,
    amenity: json['amenity'] as String,
    base: json['base'] as String,
    hashTag: json['hashTag'] as String
  );
}

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'branchID': instance.branchID,
      'branchName': instance.branchName,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'branchIntro': instance.branchIntro,
      'totalSeat': instance.totalSeat,
      'curNum': instance.curNum,
      'BusinessHour': instance.businessHour,
      'atmosphere': instance.atmosphere,
      'music': instance.music,
      'light': instance.light,
      'amenity': instance.amenity,
      'base': instance.base,
      'hashTag': instance.hashTag,
    };
