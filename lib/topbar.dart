import 'package:flutter/material.dart';
import 'manager.dart';

class Topbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TopbarState();
}

class _TopbarState extends State<StatefulWidget> {
  _TopbarState();

  @override
  void initState() {
    super.initState();

    gManager.on("CHANGE_DIR", onChangeDir);
  }

  @override
  void dispose() {
    super.dispose();
    gManager.off("CHANGE_DIR", onChangeDir);
  }

  void onChangeDir(dynamic) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dirs = gManager.dirs;
    var tabWidgets = <Widget>[];
    var index = gManager.index;

    for (int i = 0; i < dirs.length; ++i) {
      PathInfo pathInfo = dirs[i];

      List<String> names = pathInfo.subNames;

      var widgets = <Widget>[];
      var length = names.length;
      for (int j = 0; j < length; ++j) {
        widgets.add(SizedBox(
          child: InkWell(
            child: Text(
              " " + names[j] + " ",
              style: TextStyle(
                color: index == i ? Theme.of(context).primaryColor : Colors.black,
                fontSize: 13,
              ),
            ),
            onTap: () {
              if (gManager.index == i) {
                var subPath = pathInfo.subPath(j + 1);
                pathInfo.reset(subPath);
                gManager.emit("CHANGE_DIR");
              } else {
                gManager.index = i;
                gManager.emit("CHANGE_DIR");
              }
            },
        )));
        if (j < length - 1) {
          widgets.add(SizedBox(
            child: Text(
              ">",
            ),
          ));
        }
      }

      var item = Expanded(
        child: InkWell(
          child: Container(
            color: index == i
                ? Color.fromRGBO(240, 240, 240, 1.0)
                : Color.fromRGBO(154, 154, 154, 1.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: widgets,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: double.infinity,
                  child: dirs.length > 1
                      ? IconButton(
                          iconSize: 15,
                          constraints:
                              BoxConstraints(minHeight: 17, minWidth: 20),
                          icon: Icon(Icons.close),
                          color: Color.fromRGBO(86, 86, 86, 1.0),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            gManager.closeDir(i);
                            gManager.emit("CHANGE_DIR");
                          },
                        )
                      : null,
                ),
                Container(
                  width: 0.1,
                  color: Color.fromRGBO(200, 200, 200, 1.0),
                ),
              ],
            ),
          ),
          onTap: () {
            if (i == gManager.index) return;

            gManager.index = i;
            gManager.emit("CHANGE_DIR");
          },
        ),
      );
      tabWidgets.add(item);
    }

    if (dirs.length < 3) {
      tabWidgets.add(Container(
        child: IconButton(
          iconSize: 15,
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.add, size: 30,),
          onPressed: () {
            gManager.openDir();
            gManager.emit("CHANGE_DIR");
            setState(() {});
          },
        ),
        color: Colors.grey[300],
      ));
    }

    return Column(
      children: <Widget>[
        Container(
          height: 40,
          // margin: EdgeInsets.only(bottom: 0),
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(154, 154, 154, 1.0),
          child: Row(
            children: tabWidgets,
          ),
        ),
        SizedBox(
          height: 1
        ),
        Container(
          color: Colors.black12,
          child:     FlatButton(
            onPressed: () {
              if (gManager.curPath.path != DEFAULT_PATH) {
                gManager.curPath.reset(DEFAULT_PATH);
                gManager.emit('CHANGE_DIR');
              }
            },
            // color: Colors.black12,
            child: Container(
              child: Row(
                children: [
                  Spacer(),
                  Icon(Icons.home),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '返回Home文件夹',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Spacer()
                ],
              ),
              
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   gradient: LinearGradient(colors: [Colors.white, Colors.black12]),
              //   // boxShadow: <BoxShadow>[
              //   //   BoxShadow(
              //   //     color: Colors.black38,
              //   //     offset: Offset(0.0, 1.0),
              //   //     blurRadius: 1.0
              //   //   )
              //   // ]
              // ),
            )
          ),
        ),
      ],
    );
  }
}
