import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/screen/store/store_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  StoreCard({Key key, this.index, this.branchInfo}) : super(key: key);
  final int index;
  final Branch branchInfo;
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/store_detail',arguments: branchInfo);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.grey, offset: Offset(6, 6)),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 200,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  httpHeaders :{"Authorization"  : "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}"} ,
                  fit: BoxFit.cover,
                  imageUrl: "http://3.34.91.138:8000/api/resources/${branchInfo.branchID}/main.png", //"https://picsum.photos/300/300?image=${40 + index + 1}",
                  placeholder: (context, url) => Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 0,top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        branchInfo.branchName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        'assets/new.png',
                        height: 17,
                        fit: BoxFit.fitHeight,
                      ),
//                      IconButton(
//                        icon: Icon(Icons.add_location),
//                        iconSize: 36,
//                        onPressed: () {},
//                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        branchInfo.hashTag,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child : Text(
                          '${branchInfo.price}원 / 1h',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
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
