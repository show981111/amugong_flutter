import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/reservation.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:amugong/widget/showTwoButtonDialog.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationTab extends StatefulWidget {

  @override
  _ReservationTabState createState() => _ReservationTabState();
}


class _ReservationTabState extends State<ReservationTab> {
  final WebClient _webClient = locator<WebClient>();
  Future reservationFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationFuture = _webClient.getMyReservation(term: printFormattedYearAndMonth(DateTime.now()), option: 'unused');
  }
  @override
  Widget build(BuildContext context) {
    List<Reservation> _myReservationList = new List<Reservation>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return
      Container(
          padding: EdgeInsets.symmetric(
            vertical: 50,
          ),
          color: AppColor.backgroundColor,
          child :
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 77,
            child:
            Stack(
  //            alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top : 35,
                  left : 42,
                  child :
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: '"입퇴실 시 ', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          TextSpan(text: 'QR코드', style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.mainColor, fontSize: 20)),
                          TextSpan(text: '를 찍어주세요!"', style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16)),
                        ],
                      ),
                  )
                ),
              Positioned(
                right: 35 ,
                child:Image.asset(
                  'assets/qrIcon.png',
                  scale: 1,
                  fit : BoxFit.fitHeight,
                )
              ),
            ],
          )
          ),
      Expanded(
//      padding: EdgeInsets.symmetric(
//        vertical: 20,
//      ),
//      color: AppColor.backgroundColor,
      child:
      Padding(
          padding: EdgeInsets.only(top:0),
          child :
      FutureBuilder(
          future: reservationFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false && !snapshot.hasError){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              DioError dioError = snapshot.error;
              print(dioError.response.statusMessage);
              String res = '오류가 발생하였습니다!';
              if(dioError.response.statusCode == 403) res = '인증서가 만료되었습니다! 재로그인후 이용해주세요!';
              return Container(
                child: Text(res),
              );
            }else{
              _myReservationList = snapshot.data;
              if(_myReservationList.length > 0 )
              {
                return myReservationList(_myReservationList);
              }else{
                return defaultView(height);
              }
            }
          }
      )
    )
      )
        ],
      )

      );
  }

  ListView myReservationList(List<Reservation> rsrvList){
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rsrvList.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 15, left: 20, right: 20),
        height: 130,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 7,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex : 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children : [
                          Text(
                            rsrvList[index].branchName,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold, height: 1.5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 13),
                            child : InkWell(
                              onTap : () async {
                                String res = await showTwoButtonDialog(context, '${rsrvList[index].branchName}의 ${rsrvList[index].startTime}에 예약을 취소하시겠습니까? ');
                                if(res == 'ok') {
                                  String result = await _webClient.deleteReservation(
                                      num: rsrvList[index].reservationNum);
                                  if(result == 'success'){
                                    setState(() {
                                      rsrvList.removeAt(index);
                                    });
                                    showMyDialog(context, '성공적으로 취소하였습니다!');
                                  }else{
                                    showMyDialog(context, result);
                                  }
                                }
                              },
                              child: Container(
                                child : Text('예약취소', style: TextStyle(fontSize: 11),),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppColor.mainColor)
                                ),
                              ),
                            )
                          ),
                        ]
                      ),
                      Text(
                        rsrvList[index].startTime.length > 10 ? rsrvList[index].startTime.substring(0,10): ' ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        rsrvList[index].startTime.length > 10 &&  rsrvList[index].endTime.length > 10
                            ? '${rsrvList[index].startTime.substring(11)}~${rsrvList[index].endTime.substring(11)}': ' ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        '좌석 ${rsrvList[index].seatIndex}번',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      Text(
                          (rsrvList[index].realStart != null && rsrvList[index].realStart.length >10  && rsrvList[index].realStart != '0000-00-00 00:00'
                          ? '${rsrvList[index].realStart.substring(11)}' : "")
                          +(rsrvList[index].realEnd != null && rsrvList[index].realEnd.length >10 && rsrvList[index].realEnd != '0000-00-00 00:00'
                          ? ' - ${rsrvList[index].realEnd.substring(11)}' : "")
                        ,
                        style: TextStyle(
                          color: Color(0xffde00a2),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 2,
                ),
                Expanded(
                  flex : 1,
                  child: InkWell(
                      onTap: () async {
                        if(rsrvList[index].realStart == null || rsrvList[index].realStart.isEmpty || rsrvList[index].realStart == '0000-00-00 00:00') {
                          bool res = await _scanEnter(context: context,
                              num: rsrvList[index].reservationNum,
                              isKing: 0,
                              seatID: rsrvList[index].seatID,
                              rsrv_startTime: rsrvList[index].startTime,
                              rsrv_endTime: rsrvList[index].endTime,
                              purchasedAt: rsrvList[index].purchasedAt,
                              branchID: rsrvList[index].branchID);
                          if(res){
                            setState(() {
                              rsrvList[index].realStart =DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                            });
                          }
                        }else{
                          DateTime exitRsrvTime = DateTime.parse(rsrvList[index].endTime);
                          DateTime dateTimeNow = DateTime.now();
                          final diff = dateTimeNow.difference(exitRsrvTime).inMinutes;
                          print(exitRsrvTime);
                          print(DateTime.now());
                          print(diff);
                          String message ;
                          if(diff < 0){
                            message = '아직 이용시간이 ${-diff}분 남았습니다. \n퇴장하시겠습니까?';
                          }else{
                            message = '퇴장하시겠습니까?';
                          }
                          final res = await showTwoButtonDialog(context, message);
                          if(res == 'ok'){
                            bool exitRes = await _scanExit(context: context, num: rsrvList[index].reservationNum,
                                seatID: rsrvList[index].seatID,
                                rsrv_endTime: rsrvList[index].endTime,
                                branchID: rsrvList[index].branchID);
                            if(exitRes){
                              setState(() {
                                rsrvList[index].realEnd =DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
                              });
                            }
                          }
                        }

                      },
                      child : Image.asset(
                      'assets/icon_camera.png',
                      width: 50,
                      scale: 2,
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }

  Future<bool> _scanEnter({@required BuildContext context,@required int num,@required int isKing,@required int seatID,
              @required String rsrv_startTime,@required String rsrv_endTime,@required String purchasedAt,@required int branchID }) async {
    print('scanner start');
    //스캔 시작 - 이때 스캔 될때까지 blocking
    var barcode = await BarcodeScanner.scan();
    print(barcode.type.toString());
    if(barcode.type.toString() != 'Cancelled' && barcode.rawContent != null && barcode.rawContent.isNotEmpty &&barcode.rawContent.length > 0)
    {
      String result = await _webClient.qrScanEnter(
          num: num,
          isKing: isKing,
          seatID: seatID,
          rsrv_startTime: rsrv_startTime,
          rsrv_endTime: rsrv_endTime,
          purchasedAt: purchasedAt,
          branchID: branchID,
          scanContent: barcode.rawContent
      );
      if (result.toString() == 'success') {
        showMyDialog(context, '성공적으로 입장처리 되었습니다!');
        return true;
      }else{
        showMyDialog(context, result.toString());
        return false;
      }
    }

    //String photoScanResult = await BarcodeScanner.scan();
    //String barcode = await scanner.scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.
    //setState(() => _output = barcode.rawContent);
  }

  Future<bool> _scanExit({@required BuildContext context,@required int num, @required int seatID,
                    @required String rsrv_endTime ,@required int branchID,}) async {
    print('scanner start');
    //스캔 시작 - 이때 스캔 될때까지 blocking

    var barcode = await BarcodeScanner.scan();
    print(barcode.type.toString());
    if(barcode.type.toString() != 'Cancelled' && barcode.rawContent != null && barcode.rawContent.isNotEmpty &&barcode.rawContent.length > 0)
    {
      String result = await _webClient.qrScanExit(
          num: num,
          seatID: seatID,
          rsrv_endTime: rsrv_endTime,
          branchID: branchID,
          scanContent: barcode.rawContent
      );
      if (result.toString() == 'success') {
        showMyDialog(context, '성공적으로 퇴장처리 되었습니다!');
        return true;
      }else{
        showMyDialog(context, result.toString());
        return false;
      }
    }

    //String photoScanResult = await BarcodeScanner.scan();
    //String barcode = await scanner.scan();
    //스캔 완료하면 _output 에 문자열 저장하면서 상태 변경 요청.
    //setState(() => _output = barcode.rawContent);
  }

  Column defaultView(double height){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '아무공 선물들이 \n여러분을 기다리고 있어요!!!\n지금바로 서비스를 이용하고\n설문조사에 참여해보세요!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColor.mainColor,
            borderRadius: BorderRadius.circular(30),
          ),
          width: 200,
          height: 50,
          child: Center(
            child: Text(
              '이용방법',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
//        Container(
//          child :
//        )

        Image.asset(
          'assets/no_reserv.png',
          scale: 2,
          fit : BoxFit.fitHeight,
          height: height - 450,
        ),
      ],
    );
  }
}
String printFormattedYearAndMonth(DateTime today){
  String mm;
  if(today.month < 10){
    mm = '0${today.month}';
  }else{
    mm = '${today.month}';
  }

  return '${today.year}-${mm}';
}