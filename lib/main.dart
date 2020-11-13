import 'dart:async';

import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/screen/map/map_view_tap.dart';
import 'package:amugong/screen/register/register_screen.dart';
import 'package:amugong/screen/store/store_reservation_screen.dart';
import 'package:amugong/screen/store/time_pick_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    var userProvider = Provider.of<UserProvider>(context);
    WebClient _webClient = locator<WebClient>();
    return MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('ko', 'Korea'),
        // ... other locales the app supports
      ],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.light),
        accentColor: Color(0xff9DFCBC),
        primaryColor: AppColor.mainColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: locator<CachedSharedPreference>().haveUser() ? MainScreen() : LoginScreen(),
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
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
