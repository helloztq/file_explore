import 'dart:io';

import 'package:flutter/material.dart';
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
  List<FileSystemEntity> _copyFiles = [];

  String oldPath;

  _FileListState() {
    open(manager.curPath);
  }

  @override
  void initState() {
//    getApplicationDocumentsDirectory().then((value) {
//      _files = value.listSync();
//    });
    super.initState();
    manager.on("CHANGE_DIR", onChangeDir);
  }

  @override
  void dispose() {
    manager.off("CHANGE_DIR", onChangeDir);
    super.dispose();
  }

  void onChangeDir(dynamic arg) {
    open(manager.curPath);
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var file = _files[index];
            var path = file.path;
            var lastSep = path.lastIndexOf('/');
            var fileName = path.substring(lastSep + 1);

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
                                fileName,
                                style: TextStyle(fontSize: 12),
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
                    Icon(Icons.arrow_forward),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              onTap: () {
                print("点击文件: $path");
                if (FileSystemEntity.isDirectorySync(path)) {
                  manager.curPath.reset(path);
                  manager.emit("CHANGE_DIR");
                }
              },
              onLongPress: () {
                print("路径 $path");
                if (file.existsSync() && _copyFiles.indexOf(file) < 0) {
                  _copyFiles.insert(0, file);
                }
              },
            );
          },
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
                showDialog(
                  context: context,
                  child: ClipBorder(),
                  barrierDismissible: true,
                );
              },
              color: Colors.lightBlue,
            ),
          ),
        ),
      ],
    );
  }
}
