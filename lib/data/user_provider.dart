import 'package:amugong/data/locator.dart';
import 'package:amugong/model/user.dart';
import 'package:amugong/network/web_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  WebClient web = locator<WebClient>();
  User user = new User();

//  User get userInfo => user;

  UserProvider({String from}) {
    print("Provider is called${from}");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("Provider is really called${from}");
      if (web.sp.haveUser()) {
        this.user = await web.getUser();
        if(this.user == null){
          return;
        }
        print("init user " + this.user.userID);
        print("init userName " + this.user.name);
        notifyListeners();
      }
    });
  }
  bool updateData() {
    print("update is called");
    if (web.sp.haveUser()) {
      web.getUser().then((value){
        if(this.user == null){
          return false;
        }
        this.user = value;
        print("cur user " + user.userID);
        print("cur userName " + user.name);
        notifyListeners();
        return true;
      });
    }
    return false;
  }


  void clear(){
    print("clear is called and notify");
    this.user = null;
    print(user?.userID.toString());
    notifyListeners();
  }


  void onChange() {
    notifyListeners();
  }
}
