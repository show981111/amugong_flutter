import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/model/reservation.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/screen/reservation/reservation_tab.dart';
import 'package:flutter/material.dart';

class AllReservationScreen extends StatefulWidget {
  @override
  _AllReservationScreenState createState() => _AllReservationScreenState();
}

class _AllReservationScreenState extends State<AllReservationScreen> {

  Future _fetchReservationList;
  WebClient _webClient = locator<WebClient>();

  @override
  void initState() {
    // TODO: implement initState
    _fetchReservationList = _webClient.getMyReservation(term: printFormattedYearAndMonth(DateTime.now()), option: 'all');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Reservation> allRsrvList = new List<Reservation>();
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: deviceHeight * 0.13,
              ),
              color: AppColor.backgroundColor,
              child:
              Container(
                child:
                  FutureBuilder(
                    future: _fetchReservationList,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData == false && !snapshot.hasError){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }else if(snapshot.hasError){
                        String res = '오류가 발생하였습니다!';
                        if(snapshot.error == 'Forbidden') res = '인증서가 만료되었습니다! 재로그인후 이용해주세요!';
                        return Container(
                          child: Text(res),
                        );
                      }else{
                        allRsrvList = snapshot.data;
                        return myAllReservationList(allRsrvList);
                      }
                    }
                  ),
              )
          ),
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
            child:
          AppBar(
            elevation: 0,
            toolbarHeight: deviceHeight * 0.09,
            leading:
            Padding(
              padding: EdgeInsets.only(left: 10),
              child :  InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child : CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColor.backgroundColor,
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColor.mainColor,
                    size: 30,
                  ),
                ),
              ),
            ),
            title: Text(
              "이용 내역",
              style: TextStyle(
                color : Colors.black,
//            fontFamily: 'Jalnan',
//            color: AppColor.mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
          )
          ),
          Positioned(
            top: deviceHeight * 0.08,
            right: 0,
            child:Image.asset(
              'assets/allReservationListIcon.png',
              scale: 1.3,
              fit : BoxFit.fill,
            )
          ),
        ],
      ),
    );
  }

  ListView myAllReservationList(List<Reservation> rsrvList){
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rsrvList.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 18, left: 26, right: 26),
        height: 105,
        child: Card(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(20),
//          ),
          elevation: 7,
          child: Container(
            padding: EdgeInsets.only(top: 5),
            child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child : Text(
                        '${rsrvList[index].branchName}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:FontWeight.w600,
                        ),
                      ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Divider(
                    height: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10,top : 5),
                    child : Text(
                      '좌석 번호 ${rsrvList[index].seatIndex}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
//                        fontWeight:FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10,top : 2),
                    child : Text(
                      usedTimeString(rsrvList[index].startTime, rsrvList[index].endTime, '예약 시간'),
                      style: TextStyle(
                        decoration: rsrvList[index].status == 0 ? TextDecoration.lineThrough : null,
                        color: Colors.grey,
                        fontSize: 13,
//                        fontWeight:FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.spaceAround,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10,top : 2),
                        child : Text(
                          usedTimeString(rsrvList[index].realStart, rsrvList[index].realEnd, '이용 시간'),
                          style: TextStyle(
                            fontWeight:FontWeight.w600,
                            fontSize: 13,
//                        fontWeight:FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10,top : 2),
                        child : Text(
                          '${rsrvList[index].price}원',
                          style: TextStyle(
                            color: Color(0xff4127D1),
                            fontWeight:FontWeight.w600,
                            fontSize: 14,
//                        fontWeight:FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}

String usedTimeString(String start, String end, String title){
  String res = title;
  if(start != null && start.isNotEmpty && start.length > 11 && start != '0000-00-00 00:00' ){
    if(title == '이용 시간')
    {
      res += ' ${start.substring(11)}';
    }else{
      res += ' ${start}';
    }
  }
  if(end != null && end.isNotEmpty && end.length > 11 && start != '0000-00-00 00:00'){
    res += ' - ${end.substring(11)}';
  }
  return res; 
}