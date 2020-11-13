import 'package:json_annotation/json_annotation.dart';

part 'seat.g.dart';

//{
//"FK_SEAT_branchID": 1,
//"seatID": 1,
//"startTime": null,
//"endTime": null,
//"real_start": null,
//"real_end": null,
//"FK_RSRV_userID": null,
//"num": null
//},
@JsonSerializable()
class Seat {
  @JsonKey(name: 'FK_SEAT_branchID')
  int branchID;
  int seatID;
  String startTime;
  String endTime;
  @JsonKey(name: 'real_start')
  String realStart;
  @JsonKey(name: 'real_end')
  String realEnd;
  @JsonKey(name: 'FK_RSRV_userID')
  String userID;
  int num;
  int plug;
  int seatIndex;

  Seat({
    this.branchID,
    this.seatID,
    this.startTime,
    this.endTime,
    this.realStart,
    this.realEnd,
    this.userID,
    this.num,
    this.plug,
    this.seatIndex
  });


  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);
  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
