import 'dart:io';

import 'package:file_explore3/manager.dart';
import 'package:flutter/material.dart';
import 'package:file_utils/file_utils.dart';

import 'manager.dart';
import 'toast.dart';

class _PasteView extends StatefulWidget {
  final BuildContext rootContext;

  const _PasteView(this.rootContext);

  @override
  _PasteViewState createState() {
    return _PasteViewState();
  }
}

class _PasteViewState extends State<_PasteView>
    with SingleTickerProviderStateMixin {
  // Animation _animation;
  var _right = .0;

  @override
  void initState() {
    // Future.delayed(Duration(microseconds: 10), () {
    //   setState(() {
    //     _right = 0;
    //   });
    // });
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
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                var path = gManager.copyFiles[index];
                var baseName = FileUtils.basename(path);

                return Container(
//                  height: 80,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        color: Colors.yellow[800],
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        baseName,
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.none,
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
                                  gManager.removeCopyFile(path);
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
                              onPressed: () {
                                // if (FileUtils.)
                                String openDir = gManager.curPath.path;

                                if (FileSystemEntity.isFileSync(path)) {
                                  String baseName = FileUtils.basename(path);
                                  String newPath = openDir;
                                  if (openDir[openDir.length - 1] != "/") {
                                    newPath = newPath + "/";
                                  }
                                  newPath += baseName;

                                  print("拷贝文件：${newPath}");

                                  File f = File(path);
                                  f.copy(newPath).then((value) {
                                      gManager.emit("CHANGE_DIR");
                                  });
                                }

                                // if (FileSystemEntity.isDirectorySync(path) &&
                                //     curdir == path) {
                                // final snackBar = SnackBar(
                                //   content: Text('Helo'),
                                //   behavior: SnackBarBehavior.floating,
                                //   duration: Duration(seconds: 2),
                                // );

                                // Scaffold.of(widget.rootContext).removeCurrentSnackBar()
                                // Scaffold.of(widget.rootContext).showSnackBar(snackBar);
                                // }
                                // toast(context, "床前明月光，疑是地上霜！");

                                // gManager.pastFile(path);
                                // print("dirname: ${FileUtils.dirname(path)}");
                              },
                              textColor: Colors.white,
                            ),
                          ),
                          Spacer(flex: 1),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 30,
                );
              },
              itemCount: gManager.copyFiles.length,
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
  final BuildContext rootContext;

  const ClipBorder(this.rootContext);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _PasteView(this.rootContext),
    );
  }
}
