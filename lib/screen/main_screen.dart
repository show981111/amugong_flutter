import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/user_provider.dart';
import 'package:amugong/screen/map/map_view_tap.dart';
import 'package:amugong/screen/profile/profile_tab.dart';
import 'package:amugong/screen/reservation/reservation_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home/home_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin{
  final List<MyTabs> _tabs = [
    new MyTabs(isSearch: true,isMap: false ),
    new MyTabs(isSearch: false,isMap: true ),
    new MyTabs(isSearch: false,isMap: true ),
    new MyTabs(isSearch: false,isMap: true ),
  ];
  MyTabs _myHandler ;
  TabController _controller ;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _controller = new TabController(length: 4, vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
  }

  void _handleSelected() {
    setState(() {
      print("set tabs ");
      _myHandler= _tabs[_controller.index];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    print("dispose called");
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    return
//      ChangeNotifierProvider<UserProvider>(
//      create: (context) => UserProvider(),
//      child:
//      DefaultTabController(
//        length: 4,
//        child:
        Scaffold(
          backgroundColor: Colors.white,
          extendBody: true,
          appBar: _myHandler.isMap ? null : AppBar(
            actions: _myHandler.isSearch ? [
              CircleAvatar(
                backgroundColor: Color(0xffEDECF9),
                child: IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColor.mainColor,
                    ),
                    onPressed: () {}),
              ),
              SizedBox(
                width: 10,
              ),
            ] : null,

            elevation: 0,
            centerTitle: false,
            toolbarHeight: height * 0.09,
            title: Text(
              "AMUGONG",
              style: TextStyle(
                fontFamily: 'Jalnan',
                color: AppColor.mainColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
          ) ,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
            child: Container(
              padding: EdgeInsets.only(
                bottom: 13,
                top: 10,
                left: 6,
                right: 6,
              ),
              color: Colors.white,
              child: TabBar(
                controller: _controller,
                labelPadding: EdgeInsets.all(2),
                indicator: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.secondColor,
                  border: Border.all(
                    color: AppColor.secondColor,
                  ),
                ),
                labelColor: Colors.white,
                tabs: <Tab>[
                  Tab(
                    icon: Icon(
                      Icons.home,
                      size: 32,
                      color: AppColor.mainColor,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.location_on,
                      size: 32,
                      color: AppColor.mainColor,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.vpn_key,
                      size: 32,
                      color: AppColor.mainColor,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.account_circle,
                      size: 32,
                      color: AppColor.mainColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: TabBarView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                HomeTab(),
                MapScreen(),
                ReservationTab(),
                ProfileTab(),
              ],
            ),
          ),
//        ),
    //  ),
    );
  }
}

class MyTabs {
  final bool isSearch;
  final bool isMap;
  MyTabs({this.isSearch,this.isMap});
}