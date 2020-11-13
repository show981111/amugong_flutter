// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_hour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessHour _$BusinessHourFromJson(Map<String, dynamic> json) {
  return BusinessHour(
    businessHourEnd: json['businessHourEnd'] as String,
    businessHourStart: json['businessHourStart'] as String,
    dow: json['dow'] as String,
  )..branchID = json['branchID'] as int;
}

Map<String, dynamic> _$BusinessHourToJson(BusinessHour instance) =>
    <String, dynamic>{
      'branchID': instance.branchID,
      'dow': instance.dow,
      'businessHourStart': instance.businessHourStart,
      'businessHourEnd': instance.businessHourEnd,
    };
