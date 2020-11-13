import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/model/seat.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/screen/store/time_pick_screen.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:amugong/widget/showTwoButtonDialog.dart';
import 'package:amugong/widget/store_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoreReservationScreen extends StatefulWidget {

  @override
  _StoreReservationScreenState createState() => _StoreReservationScreenState();
}

class _StoreReservationScreenState extends State<StoreReservationScreen> {
  List<String> selectedTimeLines = new List<String>(2);

  int checkedSeatNum = -1;
  List<Seat> seatList = new List<Seat>();
  WebClient _webClient = locator<WebClient>();

  String startDateTime ;
  String selectedDate;
  String endDateTime ;
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime startDefault = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().minute + 1 > 30 ? DateTime.now().hour + 1 :DateTime.now().hour ,
      DateTime.now().minute + 1 > 30 ? 0 : 30 ,
    );
    startDateTime = DateFormat('yyyy-MM-dd HH:mm').format(startDefault);
    endDateTime = DateFormat('yyyy-MM-dd HH:mm').format(
        new DateTime(
          startDefault.year,
          startDefault.month,
          startDefault.day,
          startDefault.hour,
          startDefault.minute + 30,
        )
    );
    if(startDateTime.length > 10)
    {
      selectedDate = startDateTime.substring(0,10);
    }
    print(" init " +startDateTime + " " + endDateTime + " " + selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    //if(ModalRoute.of(context).settings.arguments is Branch)
    final Branch branchInfo = ModalRoute.of(context).settings.arguments;
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // extendBody: false,
      backgroundColor: AppColor.backgroundColor,
      body:

      Stack(
        children: [
          SingleChildScrollView(
            child :
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 50,
                ),
                child:
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth,
                      height: deviceHeight*3/10,
                      child:
                      CachedNetworkImage(
                        httpHeaders :{"Authorization"  : "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}"} ,
                        fit: BoxFit.cover,
                        imageUrl: "http://3.34.91.138:8000/api/resources/${branchInfo.branchID}/seat.png",
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      seatList.clear();
                                      showDatePicker(context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(DateTime.now().year + 1, DateTime.now().month,DateTime.now().day )
                                      ).then((pickedDate) {
                                        setState(() {
                                          if(pickedDate != null){
                                            selectedDate = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                                            startDateTime = '${selectedDate} ${selectedTimeLines[0]}';
                                            endDateTime = '${selectedDate} ${selectedTimeLines[1]}';
                                          }

                                        });
                                      });
                                    },
                                    child :
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 4, color: Colors.grey, offset: Offset(3, 3)),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                                      margin: EdgeInsets.only(bottom: 12),
                                      child: Center(
                                        child: Text(
                                          selectedDate != null && selectedDate.isNotEmpty && startDateTime.length > 10
                                              ? selectedDate : startDateTime.substring(0,10) ,
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                )
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    seatList.clear();
                                    final result = await Navigator.of(context).push(MaterialPageRoute<List<String>>(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context) {
                                          return TimePickerScreen();
                                        }
                                    ));
                                    setState(() {
                                      if(result != null && result.length > 0)
                                      {
                                        selectedTimeLines = result;
                                        startDateTime = '${selectedDate} ${selectedTimeLines[0]}';
                                        endDateTime = '${selectedDate} ${selectedTimeLines[1]}';
                                      }
                                    });
                                  },
                                  child:
                                    Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4, color: Colors.grey, offset: Offset(3, 3)),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: Center(
                                      child: Text(
                                        selectedTimeLines != null && selectedTimeLines.length > 0 && selectedTimeLines[0] != null && selectedTimeLines[1] != null   ?
                                        '${selectedTimeLines[0]}~${selectedTimeLines[1]}':
                                        '시간 설정',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              // boxShadow: [
                              //   BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(0, 4)),
                              // ],
                            ),
                            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
                            margin: EdgeInsets.only(bottom: 12),
                            child: Center(
                              child: Text(
                                '좌석선택',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
              //Expanded(
              Container(

               child:
//               Column(
//
//              )//seatListView(deviceWidth)
                startDateTime != null && startDateTime.length == 16 && endDateTime != null && endDateTime.length == 16 ?
                FutureBuilder(
                    future: _webClient.getSeatList(branchID: branchInfo.branchID, startTime: startDateTime, endTime: endDateTime),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData == false && !snapshot.hasError){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else if(snapshot.hasError){
                        String res = "오류가 발생하였습니다!";
                        DioError dioError = snapshot.error;
                        if(dioError.response != null) {
                          if (dioError.response.statusCode == 403) {
                            res = "다시 로그인을 해주세요!";
                          } else if (dioError.response.statusCode == 404) {
                            if (selectedTimeLines[0] == null) {
                              res = "현재 영업시간이 아닙니다!";
                            } else {
                              res = "선택하신 시간은 영업시간이 아닙니다!";
                            }
                          } else {
                            res = "날짜를 다시한번 확인해주세요!";
                          }
                        }
                        return Container(
                          height: deviceHeight/3,
                          child: Text(res,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w800,
                              fontSize: 23
                            ),),
                        );
                      }else{
                        seatList = snapshot.data;
                        print(seatList.length);
                        return seatListView(deviceWidth);
                      }
                    }
                ):
                Container(
                  height: deviceHeight/3,
                )
              ),
              SizedBox(
                height: 70,
              )
            ]
            ),

            ////////////////////////////////////////////////////
          ),
          Positioned(
            left: 15,
            top: 40,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: AppColor.mainColor,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColor.backgroundColor,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned.fill(
//            left: 15,
            bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    if(startDateTime != null && startDateTime.length == 16 && startDateTime != null && startDateTime.length == 16 && checkedSeatNum != -1) {
                      String message = '${branchInfo
                          .branchName}에서 ${checkedSeatNum}번 좌석 ${startDateTime} ~ ${endDateTime} 으로 예약하시겠습니까?';
                      final result = await showTwoButtonDialog(
                          context, message);
                      if (result == 'ok') {
                        print(seatList[checkedSeatNum].seatID);
                        String res = await _webClient.reserveSeat(
                            seatID: seatList[checkedSeatNum].seatID,
                            startTime: startDateTime,
                            endTime: endDateTime);
                        if (res.toString() == 'success') {
                          showMyDialog(context, '성공적으로 예약하였습니다!').then((value) {
                            setState(() {
                              seatList[checkedSeatNum].userID = "myself";
                              seatList[checkedSeatNum].startTime =
                                  startDateTime;
                              seatList[checkedSeatNum].endTime = endDateTime;
                            });
                          });
                        }
                        else{
                          showMyDialog(context, res.toString());
                        }
                      }
                    }else if(checkedSeatNum == -1){
                      showMyDialog(context, "좌석을 선택해주세요!");
                    }else{
                      showMyDialog(context, "날짜와 시간을 설정해주세요!");
                    }
                  },
                  child: Container(
                    width: deviceWidth * 0.8,
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 60,
                    child: Center(
                      child: Text(
                        '예약하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          )
        ],
      ),
      );
  }

  ListView seatListView(double deviceWidth){
    return ListView.builder(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: seatList.length,
        itemBuilder: (context, index) => index != -1
            ? Container(
          height: 60,
          width: deviceWidth,
          padding: EdgeInsets.only(bottom: 5),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  width: 50,
                  child:
                    Text(
                      '$index번 ${seatList[index].seatIndex}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ),
                SizedBox(width: 8),
                seatList[index].plug == 0 ? Container(width: 18):
                Image.asset(
                  'assets/icon_plug.png',
                  width: 18,
                  height: 18,
                  fit: BoxFit.cover,
                ),
                seatList[index].userID == null ? Container() :
                Text(
                    seatList[index].startTime.length > 10 && seatList[index].endTime.length > 10 ?
                    '${seatList[index].startTime.substring(10)}~${seatList[index].endTime.substring(10)} 이용 중' :
                    '',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    checkedSeatNum != index
                        ? Icons.radio_button_off
                        : Icons.radio_button_on,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    if(seatList[index].userID == null) {
                      setState(() {
                        checkedSeatNum = index;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        )
            : Text(''));
  }

}
