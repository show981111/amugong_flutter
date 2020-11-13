// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

//@JsonKey(name: 'FK_SEAT_branchID')
//int branchID;
//int seatID;
//String startTime;
//String endTime;
//@JsonKey(name: 'real_start')
//String realStart;
//@JsonKey(name: 'real_end')
//String realEnd;
//int num;
Seat _$SeatFromJson(Map<String, dynamic> json) {
  return Seat(
    branchID: json['FK_SEAT_branchID'] as int,
    seatID: json['seatID'] as int,
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    realStart: json['real_start'] as String,
    realEnd: json['real_end'] as String,
    userID: json['FK_RSRV_userID'] as String,
    num: json['num'] as int,
    plug: json['plug'] as int,
    seatIndex : json['seatIndex'] as int,
  );
}

Map<String, dynamic> _$SeatToJson(Seat instance) =>
    <String, dynamic>{
      'FK_SEAT_branchID': instance.branchID,
      'seatID': instance.seatID,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'real_start': instance.realStart,
      'real_end': instance.realEnd,
      'FK_RSRV_userID': instance.userID,
      'num': instance.num,
      'plug': instance.plug,
      'seatIndex' : instance.seatIndex
    };
