import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/data/user_provider.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/store_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future _fetchBranch;
  WebClient _webClient = locator<WebClient>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBranch =_webClient.getAllBranch();
  }

  @override
  Widget build(BuildContext context) {

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
              if(dioError.response.statusCode == 403) res = '인증서가 만료되었습니다! 재로그인후 이용해주세요!';
              return Container(
                child: Text(res),
              );
            }else{
              branchList = snapshot.data;
              return Tab(
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