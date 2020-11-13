import 'dart:io';

import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/data/user_provider.dart';

import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  GlobalKey<FormState> _key = GlobalKey();
  String _id;
  String _password;
  WebClient _webClient = locator<WebClient>();
  String _token;

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    iOS_Permission();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
        print(_token);

      });

    });
  }
  @override
  Widget build(BuildContext context) {
    // _webClient.sp.clearAll();
    var userProvider = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: _key,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            iconSize: 36,
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WELCOME!',
                  style: TextStyle(
                    fontFamily: 'Jalnan',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  onSaved: (newValue) => _id = newValue,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'PHONE',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'PASSWORD',
                  ),
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () async {
                    _key.currentState.save();
                    String res;
                    if(_token != null)
                    {
                      res = await _webClient.login(id: _id, password: _password, token: _token);
                    }else{
                      res = await _webClient.login(id: _id, password: _password);
                    }
                    if (res == null) {
                      userProvider.updateData();
                      Navigator.pushReplacementNamed(context, '/main');
//                      Navigator.pushNamedAndRemoveUntil(
//                          context, '/main', (Route<dynamic> route) => false);
                    }
                    else {
                      showMyDialog(context, res);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: width,
                    height: 60,
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: width,
                    height: 60,
                    child: Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    '아이디/비밀번호 찾기',
                    style: TextStyle(
                      color: AppColor.mainColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
