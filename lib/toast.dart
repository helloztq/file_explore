import 'package:flutter/material.dart';

void toast(BuildContext context, String str) {
  // Animation _animation = Animation();

  showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Color.fromRGBO(0, 0, 0, 0),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        // Future.delayed(Duration(seconds: 2), () {
        //   Navigator.of(context).pop();
        // });
        

        return Center(
          child: Container(
            constraints: BoxConstraints.loose(Size(300, double.infinity)),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.black,
            ),
            padding: EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
            child: Text(
              str,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              // softWrap: false,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      });
}
