import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  bool _isLoading = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
      body: Stack(
        children: [
          WebView(
              onPageFinished: (_){
                setState(() {
                  _isLoading = false;
                });
              },
              initialUrl: 'https://blog.naver.com/PostView.nhn?blogId=amu_company&logNo=222150075010&parentCategoryNo=&categoryNo=1&viewDate=&isShowPopularPosts=false&from=postView',
              javascriptMode: JavascriptMode.unrestricted,

            ),
          _isLoading ? Center( child: CircularProgressIndicator()) : Container(),

        ],
      )
    );
  }
}
