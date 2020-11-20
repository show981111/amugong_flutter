import 'package:flutter/material.dart';

Future<String> showTwoButtonDialog(BuildContext context, String message, {Container imageContainer}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // user dont have button!
    builder: (BuildContext context) {
      return AlertDialog(
        content:
//        SingleChildScrollView(
//          child: Text(
//              message
//          ),
//        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            imageContainer == null ? Container() :
                SizedBox(height: 10,),
            imageContainer == null ? Container() :
                imageContainer
          ],
        ),

        actions: <Widget>[
          FlatButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
          ),
          FlatButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.pop(context, 'ok');
            },
          )
        ],
      );
    },
  );
}