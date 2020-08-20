import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_utils/file_utils.dart';
import 'manager.dart';
import 'clipborder.dart';

class FilesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FileListState();
  }
}

class _FileListState extends State<StatefulWidget> {
  List<FileSystemEntity> _files = [];
  // List<FileSystemEntity> _copyFiles = [];

  String oldPath;

  _FileListState() {
    open(gManager.curPath);
  }

  @override
  void initState() {
//    getApplicationDocumentsDirectory().then((value) {
//      _files = value.listSync();
//    });
    super.initState();
    gManager.on("CHANGE_DIR", onChangeDir);
  }

  @override
  void dispose() {
    gManager.off("CHANGE_DIR", onChangeDir);
    super.dispose();
  }

  void onChangeDir(dynamic arg) {
    open(gManager.curPath);
    setState(() {});
  }

  void open(PathInfo fp) {
    try {
      _files = Directory(fp.path).listSync();
      _files.sort((FileSystemEntity f1, FileSystemEntity f2) {
        var path1 = f1.path;
        var lastSep1 = path1.lastIndexOf('/');
        var fileName1 = path1.substring(lastSep1 + 1);

        var path2 = f2.path;
        var lastSep2 = path2.lastIndexOf('/');
        var fileName2 = path2.substring(lastSep2 + 1);

        var type1 = FileSystemEntity.isDirectorySync(path1);
        var type2 = FileSystemEntity.isDirectorySync(path2);

        if (type1 == type2) {
          return fileName1.compareTo(fileName2);
        }

        if (type1) {
          return -1;
        }

        return 1;
      });
    } on IOException {
      _files = [];
    }
  }

  Widget itemBuilder(BuildContext context, int index) {
    var file = _files[index];
    var path = file.path;

    var baseName = FileUtils.basename(path);

    var desc;
    if (FileSystemEntity.isDirectorySync(path)) {
      try {
        var len = Directory(path).listSync().length;
        desc = "$len项";
      } on IOException {
        desc = "0项";
        print("desc exception");
      }
    } else {
      desc = "${file.statSync().size}kb";
    }

    return InkWell(
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Icon(
              FileSystemEntity.isDirectorySync(path)
                  ? Icons.folder
                  : Icons.description,
              color: Theme.of(context).primaryColor,
              size: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    baseName,
                    style: TextStyle(fontSize: 13),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        desc,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Text(
                        file.statSync().modified.toString(),
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // Spacer(),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: FileSystemEntity.isDirectorySync(path)
                  ? Icon(Icons.arrow_forward)
                  : null,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      onTap: () {
        print("点击文件: $path");
        if (FileSystemEntity.isDirectorySync(path)) {
          gManager.curPath.reset(path);
          gManager.emit("CHANGE_DIR");
        }
      },
      onLongPress: () {
        // print("路径 $path");
        showModalBottomSheet(
            context: context,
            barrierColor: Color.fromRGBO(100, 100, 100, 0),
            backgroundColor: Color.fromRGBO(230, 230, 230, 1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                )
              ),
            builder: (context) {
              return Container(
                height: 80,
                child: Row(
                  children: [
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            if (file.existsSync()) {
                              gManager.addCopyFile(path);
                            }
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "复制",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            if (file.existsSync()) {
                              file.delete();
                              gManager.emit("CHANGE_DIR");
                            }
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          "删除",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.separated(
          itemBuilder: itemBuilder,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 10,
            );
          },
          itemCount: _files.length,
        ),
        Positioned(
          bottom: 200,
          right: 0,
          child: Container(
            width: 50,
            height: 40,
            // color: Colors.blue,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.grey[400],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                // showDialog(
                //   context: context,
                //   child: ClipBorder(context),
                //   barrierDismissible: true,
                // );
                var c = context;
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return ClipBorder(c);
                        },
                        opaque: false,
                        barrierDismissible: true,
                        barrierColor: Color.fromRGBO(100, 100, 100, 0.4),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        barrierLabel: "Good"));
              },
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
