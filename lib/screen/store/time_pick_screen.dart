import 'package:amugong/const/AppColor.dart';
import 'package:amugong/screen/store/store_reservation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerScreen extends StatefulWidget {
  String startTime = "";
  String endTime = "";
  String selectedTime = "";
//  Duration initialTimer = Duration(hours : DateTime.now().hour);

  @override
  _TimePickerScreenState createState() => _TimePickerScreenState();
}

class _TimePickerScreenState extends State<TimePickerScreen> {

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
          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
              InkWell(
                onTap: (){
                  widget.selectedTime = "";
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext builder)
                      {
                        return TimePicker(0);
                      },
                    );
                },
                child :
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
                    child: Center(
                      child: Text(
                        widget.startTime == "" ? '시간 선택' : widget.startTime,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ),
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
              InkWell(
                onTap: (){
                  widget.selectedTime = "";
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builder)
                  {
                    return TimePicker(1);
                  });
                },
                child :
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
                  child: Center(
                    child: Text(
                      widget.endTime == "" ? '시간 선택' : widget.endTime,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
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

                          if(widget.startTime !=null && widget.endTime != null &&
                              widget.startTime.isNotEmpty && widget.endTime.isNotEmpty){
                            result.add(widget.startTime );
                            result.add(widget.endTime );
                          }
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

//  String _printDuration(Duration duration) {
//    String twoDigits(int n) => n.toString().padLeft(2, "0");
//    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
//  }

  Container TimePicker(int judge){
    return
      Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap : (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 120,
                            child :Text(
                              "Cancel",
                              style: TextStyle(fontSize: 15),
                          ),
                          )
                        ),
                        InkWell(
                          onTap : (){
                            setState(() {
                              DateTime cur =DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,0);
                              if(judge == 0){
                                if(widget.selectedTime == ""){
                                  widget.startTime = printFormattedTime(cur);
                                }else widget.startTime = widget.selectedTime;
                              }else{
                                if(widget.selectedTime == ""){
                                  widget.endTime = printFormattedTime(cur);
                                }else widget.endTime = widget.selectedTime;
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 120,
                            child : Align(
                              alignment: Alignment.centerRight,
                              child:
                            Text(
                                "Ok",
                              style: TextStyle(fontSize: 15),
                            ),
                            )
                          ),
                        )
                      ],
                    )
                ),
                Container(
                  height: MediaQuery.of(context).copyWith().size.height / 4,
                  child :  CupertinoDatePicker(
                    initialDateTime: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,0),
                    onDateTimeChanged: (DateTime newdate) {
                      widget.selectedTime = printFormattedTime(newdate);
                    },
                    use24hFormat: false,
                    minuteInterval: 30,
                    mode: CupertinoDatePickerMode.time,
                  )
                )
              ]
          )
      );
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
