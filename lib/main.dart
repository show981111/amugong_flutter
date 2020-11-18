import 'dart:async';

import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/screen/map/map_view_tap.dart';
import 'package:amugong/screen/password_reset/password_reset.dart';
import 'package:amugong/screen/register/register_screen.dart';
import 'package:amugong/screen/reservation/all_reservation_screen.dart';
import 'package:amugong/screen/store/store_reservation_screen.dart';
import 'package:amugong/screen/store/time_pick_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'data/cached_shared_preference.dart';
import 'data/user_provider.dart';
import 'network/web_client.dart';
import 'screen/store/store_detail_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZoned(
    () async {
      setupServiceLocator();
      await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      await locator.allReady();

      runApp(
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(from : "main"),
            child : MyApp()
          )
      );
    },
    onError: (Object error, StackTrace stackTrace) {
      // print('clear');
      // locator<CachedSharedPreference>().clearAll();
      debugPrint(error.toString());
    },
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('building');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        accentColor: Color(0xff9DFCBC),
        primaryColor: AppColor.mainColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
//      locator<CachedSharedPreference>().haveUser() ? MainScreen() : LoginScreen(),
      // ( userProvider.user?.userID == null ?  MainScreen(): LoginScreen() )
         // : LoginScreen(),
      //_webClient.getUser() != null ? LoginScreen() :
//          userProvider.user?.userID == null ?
////          (userProvider.updateData() ? MainScreen() :LoginScreen() )
//          LoginScreen()
//          :
       // MainScreen(),
      //locator<CachedSharedPreference>().haveUser() ? MainScreen() : LoginScreen(),
      routes: {
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/main': (context) => MainScreen(),
        '/map' : (context) => MapScreen(),
        '/store_detail': (context) => StoreDetailScreen(),
        '/store_reservation': (context) => StoreReservationScreen(),
        '/time_pick': (context) => TimePickerScreen(),
        '/all_reservation': (context) => AllReservationScreen(),
        '/password_reset': (context) => ResetScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebClient _webClient = locator<WebClient>();
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    //Navigator.of(context).pushReplacementNamed('/main');

    if(locator<CachedSharedPreference>().haveUser() ){
      var res;
      try {
         res = await _webClient.getUser();
      }catch(e){
        Navigator.of(context).pushReplacementNamed('/login');
      }
      if(res != null){
        Navigator.of(context).pushReplacementNamed('/main');
        return;
      }else{
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xff462AE0),
        child : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top : deviceHeight/7, left: deviceWidth/5),
              child: Text(
                "AMUGONG",
                style: TextStyle(
                  fontFamily: 'Jalnan',
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25,left: deviceWidth/5),
              child: Text(
                "아무데서나\n공부한다\n아무공",
                style: TextStyle(
                  height: 1.3,
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top : 0, left: deviceWidth/5),
              child: Image.asset(
                'assets/launchIcon.png',
                scale: 1,
                fit : BoxFit.fitWidth,
              )
            ),
          ],
        )
      ),
    );
  }
}
