import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

//{
//"num": 18,
//"FK_RSRV_userID": "01011112222",
//"FK_RSRV_seatID": 3,
//"startTime": "2020-10-04 23:15",
//"endTime": "2020-10-04 23:30",
//"real_start": "2020-10-04 23:40",
//"real_end": "2020-10-05 00:04",
//"isKing": "1",
//"purchasedAt": "2020-09-26 01:06",
//"merchant_uid": "",
//"status": 1,
//"isPaid": 1
//},
@JsonSerializable()
class Reservation {
  @JsonKey(name: 'num')
  int reservationNum; //
  @JsonKey(name: 'FK_RSRV_userID')
  String userID; //
  @JsonKey(name: 'FK_RSRV_seatID')
  int seatID; //
  String startTime; //
  String endTime; //
  @JsonKey(name: 'real_start')
  String realStart; //
  @JsonKey(name: 'real_end')
  String realEnd; //
  int isKing; //
  String purchasedAt; //
  String merchantUid; //
  int status;
  int isPaid;
  @JsonKey(name: 'FK_SEAT_branchID')
  int branchID;
  String branchName;
  int seatIndex;
  int price;


  Reservation({
    this.reservationNum,
    this.userID,
    this.seatID,
    this.startTime,
    this.endTime,
    this.realStart,
    this.realEnd,
    this.isKing,
    this.purchasedAt,
    this.merchantUid,
    this.status,
    this.isPaid,
    this.branchID,
    this.branchName,
    this.seatIndex,
    this.price
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
