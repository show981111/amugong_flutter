// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) {
  return Reservation(
    reservationNum: json['num'] as int,
    endTime: json['endTime'] as String,
    isKing: json['isKing'] as int,
    isPaid: json['isPaid'] as int,
    merchantUid: json['merchantUid'] as String,
    purchasedAt: json['purchasedAt'] as String,
    realEnd: json['real_end'] as String,
    realStart: json['real_start'] as String,
    seatID: json['FK_RSRV_seatID'] as int,
    startTime: json['startTime'] as String,
    status: json['status'] as int,
    userID: json['FK_RSRV_userID'] as String,
    branchID : json['FK_SEAT_branchID'] as int,
    branchName : json['branchName'] as String,
    seatIndex : json['seatIndex'] as int,
    price : json['price'] as String,
  );
}

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'num': instance.reservationNum,
      'FK_RSRV_userID': instance.userID,
      'FK_RSRV_seatID': instance.seatID,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'real_start': instance.realStart,
      'real_end': instance.realEnd,
      'isKing': instance.isKing,
      'purchasedAt': instance.purchasedAt,
      'merchantUid': instance.merchantUid,
      'status': instance.status,
      'isPaid': instance.isPaid,
      'FK_SEAT_branchID' : instance.branchID,
      'branchName' : instance.branchName,
      'seatIndex' : instance.seatIndex,
      'price' : instance.price
    };
