import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/screen/store/store_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoreCardHorizontal extends StatelessWidget {
  StoreCardHorizontal({Key key, this.index, this.branchInfo}) : super(key: key);
  final int index;
  final Branch branchInfo;
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/store_detail',arguments: branchInfo);
      },
      child: Container(
        width: deviceWidth*17/20,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey, offset: Offset(6, 6)),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: deviceWidth*10/20,
              height: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: CachedNetworkImage(
                  httpHeaders :{"Authorization"  : "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}"} ,
                  fit: BoxFit.cover,
                  imageUrl: "http://3.34.91.138:8000/api/resources/${branchInfo.branchID}/main.png",
                  placeholder: (context, url) => Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width : deviceWidth*5/20,
                    child : Text(
                      branchInfo.branchName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    width : 60,
                    child : Text(
                      branchInfo.hashTag,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.lightBlue,
//                        decoration: TextDecoration.underline,
//                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    width : 60,
                    child : Text(
                      branchInfo.atmosphere,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
