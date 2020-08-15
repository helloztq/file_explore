import 'package:file_explore3/manager.dart';
import 'package:flutter/material.dart';

class _PasteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PasteViewState();
  }
}

class _PasteViewState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {

  // Animation _animation;
  var _right = -200.0;

  @override
  void initState() {

    Future.delayed(Duration(microseconds: 10), () {
      setState(() {
        _right = 0;
      });
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: Duration(milliseconds: 250),
          bottom: 0,
          right: _right,
          top: 0,
          child: Container(
            width: 200,
//            height: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var path = manager.copyFiles[index];
                var lastSep = path.lastIndexOf('/');
                var fileName = path.substring(lastSep + 1);

                return Container(
//                  height: 80,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        color: Colors.yellow[300],
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[850],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(flex: 1),
                          Container(
                            width: 60,
                            height: 25,
                            child: OutlineButton(
                              onPressed: () {
                                setState(() {
                                  manager.removeCopyFile(path);
                                });
                              },
                              child: Text(
                                '删除',
                                style: TextStyle(fontSize: 11),
                              ),
                              shape: StadiumBorder(
                                  side: BorderSide(color: Colors.grey)),
                            ),
                          ),
                          Spacer(flex: 1),
                          Container(
                            width: 60,
                            height: 25,
                            child: RaisedButton(
                              child: Text(
                                '粘贴',
                                style: TextStyle(fontSize: 11),
                              ),
                              shape: StadiumBorder(),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {},
                              textColor: Colors.white,
                            ),
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ],
                  ),
//                    color: Colors.green,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 30,
//                  indent: 12,
//                  endIndent: 12,
                );
              },
              itemCount: manager.copyFiles.length,
              padding: EdgeInsets.all(10),
            ),
          ),
          onEnd: () {},
        ),
      ],
    );
  }
}

class ClipBorder extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _PasteView(),
    );
  }
}
