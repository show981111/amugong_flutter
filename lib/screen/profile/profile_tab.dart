import 'package:amugong/const/AppColor.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/data/user_provider.dart';
import 'package:amugong/network/web_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: height*0.08, horizontal: 40),
      color: AppColor.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(
                      0xffBAB7EF,
                    ),
                    child: Icon(
                      Icons.account_circle,
                      size: 40,
                      color: AppColor.mainColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      Provider.of<UserProvider>(context).user?.name == null ?
                        '로그인을 해주세요!'
                      :'${Provider.of<UserProvider>(context).user?.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(
                  0xffBAB7EF,
                ),
                child: Icon(
                  Icons.edit,
                  color: AppColor.mainColor,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/all_reservation');
            },
            child : Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                '구매내역',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              '공지사항',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              '설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              '라이센스',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          InkWell(
            onTap: () {
              print("tapp");
              locator<WebClient>().logOut().then((value){
                print("pushed~");
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (Route<dynamic> route) => false);
                });
              //Provider.of<UserProvider>(context)?.clear();
//              Navigator.pushNamedAndRemoveUntil(
//                  context, '/login', (Route<dynamic> route) => false);
            },
            child: Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 28),
              margin: EdgeInsets.only(bottom: 12),
              child: Text(
                '로그아웃',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ));
  }
}
