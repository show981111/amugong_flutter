import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/reservation.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
      ),
      color: AppColor.backgroundColor,
      child: FutureBuilder(
          future: reservationFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false && !snapshot.hasError){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              print(snapshot.error);
              print('error occur');
              return Container(
                child: Text('error'),
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
    );
  }

  ListView myReservationList(List<Reservation> rsrvList){
    return ListView.builder(
      itemCount: rsrvList.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 21, left: 20, right: 20),
        height: 180,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 7,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rsrvList[index].branchName
                        ,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                      ),
//                      rsrvList[index].realStart == null || rsrvList[index].realStart.isEmpty || rsrvList[index].realStart == '0000-00-00 00:00' ?
//                      Container() :
//                      Text(
//                        rsrvList[index].realStart
//                        ,
//                        style: TextStyle(
//                            fontSize: 15, fontWeight: FontWeight.bold, height: 1.5),
//                      ),
                      Text(
                        rsrvList[index].startTime.length > 10 ? rsrvList[index].startTime.substring(0,10): ' ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        rsrvList[index].startTime.length > 10 &&  rsrvList[index].endTime.length > 10
                            ? '${rsrvList[index].startTime.substring(11)}~${rsrvList[index].endTime.substring(11)}': ' ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '${rsrvList[index].seatIndex}번 좌석',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  width: 2,
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                      onTap: () async {
                        String res = await _scan(context: context, num: rsrvList[index].reservationNum, isKing: 0,
                            seatID: rsrvList[index].seatID, rsrv_startTime: rsrvList[index].startTime, rsrv_endTime: rsrvList[index].endTime,
                            purchasedAt: rsrvList[index].purchasedAt, branchID:rsrvList[index].branchID );
//                        if (await Permission.camera.request().isGranted) {
//                          String res = await _scan(context: context, num: rsrvList[index].reservationNum, isKing: 0,
//                              seatID: rsrvList[index].seatID, rsrv_startTime: rsrvList[index].startTime, rsrv_endTime: rsrvList[index].endTime,
//                              purchasedAt: rsrvList[index].purchasedAt, branchID:rsrvList[index].branchID );
//                        }
                      },
                      child : Image.asset(
                      'assets/icon_camera.png',
                      scale: 1.4,
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

  Future _scan({@required BuildContext context,@required int num,@required int isKing,@required int seatID,
              @required String rsrv_startTime,@required String rsrv_endTime,@required String purchasedAt,@required int branchID }) async {
    print('scanner start');
    //스캔 시작 - 이때 스캔 될때까지 blocking
    var barcode = await BarcodeScanner.scan();
    if(barcode.type.toString() != 'Cancelled' && barcode.rawContent != null && barcode.rawContent.isNotEmpty &&barcode.rawContent.length > 0)
    {
      if(barcode.rawContent == branchID.toString()) {
        String result = await _webClient.qrScanEnter(num: num,
            isKing: isKing,
            seatID: seatID,
            rsrv_startTime: rsrv_startTime,
            rsrv_endTime: rsrv_endTime,
            purchasedAt: purchasedAt);
        if (result.toString() == 'success') {
          showMyDialog(context, '성공적으로 입장처리 되었습니다!');
        }else{
          showMyDialog(context, result.toString());
        }
      }else{
        showMyDialog(context, '예약 내역에서 사용하시려는 지점을 다시한번 확인해주세요!');
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
          height: height - 430,
        ),
      ],
    );
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
}
