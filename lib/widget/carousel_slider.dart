import 'package:amugong/data/cached_shared_preference.dart';
import 'package:amugong/data/locator.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/network/web_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class CarouselImage extends StatefulWidget {
  final Branch branchInfo;

  CarouselImage({this.branchInfo});

  _CarouselImageState createState() => _CarouselImageState();

}

class _CarouselImageState extends State<CarouselImage> {
  List<String> keyList;
  Future fetchKeyList;
  WebClient _webClient = locator<WebClient>();
  final CachedSharedPreference sp = locator<CachedSharedPreference>();
  List<CachedNetworkImage> imageList = new List<CachedNetworkImage>();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchKeyList = _webClient.getImageKeyList(branchID: widget.branchInfo.branchID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchKeyList,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false && !snapshot.hasError){
          return Container(
            height: MediaQuery.of(context).size.height*0.4,
            child :
              Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: CircularProgressIndicator(),
              ),
          ));
        }else if(snapshot.hasError){
          print(snapshot.error);
          return Container(
            child: Text('error'),
          );
        }else{
          keyList = snapshot.data;
          return new Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CarouselSlider(
                  items: keyList.map((key){
                    return Builder(
                        builder:(BuildContext context){
                          return
                              CachedNetworkImage(
                                httpHeaders :{"Authorization"  : "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}"} ,
                                fit: BoxFit.cover,
                                imageUrl: "http://3.34.91.138:8000/api/resources/${widget.branchInfo.branchID}/${key}", //"https://picsum.photos/300/300?image=${40 + index + 1}",
                                placeholder: (context, url) => Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              );
                        }
                    );
                  }).toList(),
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
//                      height: 1.3,
                      aspectRatio: 1.3,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      onPageChanged : (index, reason) {
                        //print("index " +index.toString());
                        if(index <= keyList.length) {
                          setState(() {
                            _currentPage = index;
                          });
                        }
                      }
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: makeIndicator(keyList, _currentPage),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

List<Widget> makeIndicator(List list, int _currentPage){
  print(_currentPage);
  List<Widget> results = [];
  for(int i = 0; i < list.length; i++)
  {
    results.add(
        Container(
          width:  8,
          height: 8,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? Colors.black
                : Colors.grey,
          ),
        )
    );
  }
  return results;
}