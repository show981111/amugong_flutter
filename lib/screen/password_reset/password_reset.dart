import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/network/web_client.dart';
import 'package:amugong/widget/showOneButtonDialog.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController pwCheckController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

  bool isSent = false;
  bool isVerified = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    pwCheckController.dispose();
    codeController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    WebClient _webClient = locator<WebClient>();
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
                '비밀번호 재설정',
                style: TextStyle(
                  fontFamily: 'Jalnan',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '휴대폰 번호',
                      ),
                    ),
                  ),
                  FlatButton(
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        child: Text(
                          '인증하기',
                        ),
                      ),
                      textColor: AppColor.mainColor,
                      color: Colors.white,
                      onPressed: () async {
                        final String res = await _webClient.verifyPhone(userID: phoneNumberController.text);
                        if(res == "success"){
                          setState(() {
                            isSent = true;
                          });
                          showMyDialog(context, '문자로 인증코드가 전송되었습니다! 요휴기간은 3분입니다!');
                        }else{
                          showMyDialog(context, res);
                        }
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible : isSent,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: codeController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '인증번호',
                        ),
                      ),
                    ),
                    FlatButton(
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.grey,
                              )),
                          child: Text(
                            '인증확인',
                          ),
                        ),
                        textColor: AppColor.mainColor,
                        color: Colors.white,
                        onPressed: () async {
                          final String res = await _webClient.verifyCode(userID: phoneNumberController.text, code: codeController.text);
                          if(res == "success"){
                            setState(() {
                              isVerified = true;
                            });
                            showMyDialog(context, '인증에 성공하였습니다!');
                          }else{
                            showMyDialog(context, res);
                          }
                        }),
                  ],
                ),
              ),
              Visibility(
                visible: isVerified,
                child : TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                  ),
                )
              ),
              SizedBox(
                height: 10,
              ),
            Visibility(
              visible: isVerified,
              child : TextFormField(
                  controller: pwCheckController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: '비밀번호 확인',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
//              TextFormField(
//                keyboardType: TextInputType.emailAddress,
//                decoration: InputDecoration(
//                  hintText: '생년월일 6자리',
//                ),
//              ),
              Align(
                heightFactor: 3,
                child:
                InkWell(
                  onTap: () async {
                    if(passwordController.text == pwCheckController.text){
                      final String res = await _webClient.resetPassword(userID: phoneNumberController.text, userPassword: passwordController.text);
                      if(res == 'success'){
                        showMyDialog(context, '성공적으로 비밀번호를 재설정 하였습니다!').then((value) {
                          Navigator.pushNamed(context, '/login');
                        });
                      }else{
                        showMyDialog(context, res);
                      }
                    }else{
                      showMyDialog(context, '비밀번호와 비밀번호 확인이 일치하지 않습니다!');
                    }
                  },
                  child : Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
