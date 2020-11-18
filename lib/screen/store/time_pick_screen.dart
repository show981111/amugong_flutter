import 'package:amugong/const/AppColor.dart';
import 'package:amugong/screen/store/store_reservation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimePickerScreen extends StatefulWidget {
  String startTime = "";
  String endTime = "";
  String selectedTime = "";
//  Duration initialTimer = Duration(hours : DateTime.now().hour);

  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {
  List<Text> times = List<Text>();
  List<Text> minutes = [Text('00'),Text('30')];
  int initialHourIndex;
  String selectedStartHour;
  String selectedStartMin ;
  String selectedEndHour;
  String selectedEndMin ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeTimeList();
    initialHourIndex = DateTime.now().hour;
    print(DateTime.now().hour);
    selectedStartHour = times[initialHourIndex].data;
    selectedStartMin = '00';
    selectedEndHour = times[initialHourIndex].data;
    selectedEndMin = '00';
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          iconSize: 36,
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '시간 설정',
                style: TextStyle(
                  color: AppColor.mainColor,
                  fontFamily: 'Jalnan',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 40),
              Text(
                '시작 시간',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
  //                      width: ,
                        child:
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: initialHourIndex),
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedStartHour = times[index].data;
                            });
                          },
                          children:times,
                        ),
                      ),
                      Text(
                        '시',
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child:
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: 0),
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index) {
                            print(index);
                            setState(() {
                              selectedStartMin = minutes[index].data;
                            });
                          },
                          children: minutes,
                        ),
                      ),
                      Text(
                        '분',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 15),

              Text(
                '종료 시간',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
    //                      width: ,
                        child:
                        CupertinoPicker(
                          scrollController: FixedExtentScrollController(initialItem: initialHourIndex),
                          itemExtent: 40.0,
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedEndHour = times[index].data;
                            });
                          },
                          children:times,
                        ),
                      ),
                      Text(
                        '시',
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                        child:
                        CupertinoPicker(
                          itemExtent: 40.0,
                          scrollController: FixedExtentScrollController(initialItem: 0),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              selectedEndMin = minutes[index].data;
                            });
                          },
                          children: minutes,
                        ),
                      ),
                      Text(
                        '분',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
              ),
              Align(
                heightFactor: 3,
                child:
                InkWell(
                  onTap: () {

                  },
                  child:
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(3, 3)),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: width,
                      height: 60,
                      child: InkWell(
                        onTap: (){
                          List<String> result = new List<String>();
                          result.add('${selectedStartHour}:${selectedStartMin}');
                          result.add('${selectedEndHour}:${selectedEndMin}');
                          Navigator.pop(context, result);
                        },

                        child :
                          Center(
                            child: Text(
                              '확 인',
                              style: TextStyle(
                                color: AppColor.mainColor,
                                fontFamily: 'Jalnan',
                                fontSize: 23,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      )
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void makeTimeList(){
    for(int i = 0; i <= 24; i++){
      if(i < 10){
        times.add(Text('0${i}', style: TextStyle(fontSize: 24),));
      }else{
        times.add(Text('${i}'));
      }
    }
  }
}

String printFormattedTime(DateTime newdate){
  String hh , mm;
  if(newdate.hour < 10){
    hh = '0${newdate.hour}';
  }else{
    hh = '${newdate.hour}';
  }
  if(newdate.minute < 10){
    mm = '0${newdate.minute}';
  }else{
    mm = '${newdate.minute}';
  }

  return '${hh}:${mm}';
}
