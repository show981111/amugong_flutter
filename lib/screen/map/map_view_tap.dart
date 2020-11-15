import 'dart:convert';
import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/store_card_horizontal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapScreen extends StatefulWidget{
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>{
  WebClient _webClient = locator<WebClient>();
  List<Branch> branchList = new List<Branch>();
  Future getBranchFuture;
  WebViewController webViewController;
  TextEditingController searchLocationController = new TextEditingController();
  int locationSet = 0;
  LocationData userLocation ;
  int _stackToView = 1;
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  //final Completer<WebViewController> _controller = Completer<WebViewController>();

  Future<void> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    userLocation = await location.getLocation();

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBranchFuture = _webClient.getAllBranch();
  }
  @override
  Widget build(BuildContext context) {

    if(userLocation != null){
      setState(() {
        locationSet = 1;
      });
      if(webViewController != null){
        print(userLocation.longitude.toString() + " / " + userLocation.latitude.toString());
        webViewController
            ?.evaluateJavascript('setCurrentLocation('+userLocation.latitude.toString()+','+userLocation.longitude.toString()+' )')
            ?.then((result) {
          // You can handle JS result here.
        });
      }
    }

    void _setReady(String val) {
      setState(() {
        _stackToView = 0;
      });
    }

    return
      IndexedStack(
        index: _stackToView,
        children : [
          Stack(
            children: <Widget>[
              WebView(
                onPageFinished: _setReady,
//                initialUrl: 'http://3.34.91.138:8000/api/map/'+'37'+'/'+'127',
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels:
                Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) {
                        //This is where you receive message from
                        //javascript code and handle in Flutter/Dart
                        //like here, the message is just being printed
                        //in Run/LogCat window of android studio
                        print(message.message);
                        var res = message.message;
    //                            var encoding = json.encode(message.message.toString());
                        var result = json.decode(res);
                        Branch selectedBranch = Branch.fromJson(result);
                        Navigator.pushNamed(context, '/store_detail', arguments: selectedBranch);
                        print(selectedBranch);
                      })
                ]),
                onWebViewCreated: (WebViewController w) {
                  webViewController = w;
                  Map<String, String> headers = {"Authorization": "Bearer " + sp.getString(SharedPreferenceKey.AccessToken)};
                  w.loadUrl('http://3.34.91.138:8000/api/map/'+'37'+'/'+'127', headers: headers);

                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child :
                  Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child :
                      FutureBuilder(
                          future: getBranchFuture,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData == false && !snapshot.hasError){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if(snapshot.hasError){
                              return Container(
                                child: Text('error'),
                              );
                            }else{
                              branchList = snapshot.data;
                              return
                                Container(
                                  height: 200,
                                    child: ListView.builder(
                                      physics: ClampingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: branchList.length,
                                      itemBuilder: (context, index) => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            StoreCardHorizontal(branchInfo: branchList[index]),
                                          ],
                                        ),
                                      ),
                                    ),
                                );
                            }
                          }
                        )
                      )
              ),
              Positioned.fill(
                top: 44,
                child: Align(
                  alignment: Alignment.topCenter,
                  child:
                      Container(
                        padding: EdgeInsets.fromLTRB(50, 8, 50, 5),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "AMUGONG",
                              style: TextStyle(
                                fontFamily: 'Jalnan',
                                color: AppColor.mainColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                print("tap");
                                webViewController
                                    ?.evaluateJavascript('goToDefault()')
                                    ?.then((result) {
                                  // You can handle JS result here.
                                });
                                },
                              child :
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 17,
                                      color: AppColor.mainColor,
                                    ),
                                    Text(
                                      "Inha Uni",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 15, color: Colors.grey, offset: Offset(6, 6)),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                    )
                ),
              ),
              Positioned(
                right: 22,
                top: 59,
                child: InkWell(
                  onTap: () async {
                    print("TAP");
                    await getUserLocation();
                    print(userLocation);
                    webViewController
                        ?.evaluateJavascript('setCurrentLocation('+userLocation.latitude.toString()+','+userLocation.longitude.toString()+' )')
                        ?.then((result) {
                      // You can handle JS result here.
                    });
                  },
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(blurRadius: 2, color: Colors.grey, offset: Offset(3, 3)),
                        ],
                      ),
                      child:
                      CircleAvatar(
                        radius: 15.0,
                        backgroundColor: AppColor.mainColor,
                        child: Icon(
                          Icons.my_location,
                          color: AppColor.backgroundColor,
                          size: 18,
                        ),
                      ),
                    )
//                    CircleAvatar(
//                      radius: 20.0,
//                      backgroundColor: AppColor.mainColor,
//                      child: Icon(
//                        Icons.my_location,
//                        color: AppColor.backgroundColor,
//                        size: 20,
//                      ),
//                    ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ]
    );
  }
}
