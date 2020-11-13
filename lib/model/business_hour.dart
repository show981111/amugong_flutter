import 'package:json_annotation/json_annotation.dart';

part 'business_hour.g.dart';

@JsonSerializable()
class BusinessHour {
  int branchID;
  String dow;
  String businessHourStart;
  String businessHourEnd;

  BusinessHour({
    this.businessHourEnd,
    this.businessHourStart,
    this.dow
  });

  factory BusinessHour.fromJson(Map<String, dynamic> json) => _$BusinessHourFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessHourToJson(this);
}
