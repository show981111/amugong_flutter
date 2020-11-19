import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/data/user_provider.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/store_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future _fetchBranch;
  WebClient _webClient = locator<WebClient>();
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBranch =_webClient.getAllBranch();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Branch> branchList= new List<Branch>();
    return Container(
      color: AppColor.backgroundColor,
      child: FutureBuilder(
        future: _fetchBranch,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false && !snapshot.hasError){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              DioError dioError = snapshot.error;
              print(dioError.response.statusMessage);
              String res = '오류가 발생하였습니다!';
              if(dioError.response.statusCode == 403) {
                res = '인증서가 만료되었습니다! 재로그인후 이용해주세요!';
//                Navigator.of(context).pushReplacementNamed('/login');
              }
              return Container(
                child: Text(res),
              );
            }else{
              branchList = snapshot.data;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children : [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height*0.1,
                      width: width-50,
                      child: CachedNetworkImage(
                        httpHeaders :{"Authorization"  : "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}"} ,
                        fit: BoxFit.fill,
                        imageUrl: "http://3.34.91.138:8000/api/resources/0/ad.png", //"https://picsum.photos/300/300?image=${40 + index + 1}",
                        placeholder: (context, url) => Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: branchList.length,
                        itemBuilder: (context, index) => Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              StoreCard(
                                index: index,
                                branchInfo: branchList[index],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                ]
              );
            }
          }
      )
    );
  }
}

//String res = await _webClient.login(id: _id, password: _password);
//                    if (res == null)
//                      Navigator.pushReplacementNamed(context, '/main');
//                    else {
//                      print(res);
//                    }