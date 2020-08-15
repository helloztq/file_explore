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

    manager.on("CHANGE_DIR", onChangeDir);
  }

  @override
  void dispose() {
    super.dispose();
    manager.off("CHANGE_DIR", onChangeDir);
  }

  void onChangeDir(dynamic) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var dirs = manager.dirs;
    var tabWidgets = <Widget>[];
    var index = manager.index;

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
            if (manager.index == i) {
              var subPath = pathInfo.subPath(j + 1);
              pathInfo.reset(subPath);
              manager.emit("CHANGE_DIR");
            } else {
              manager.index = i;
              manager.emit("CHANGE_DIR");
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
                  child: dirs.length > 1
                      ? IconButton(
                          iconSize: 15,
                          constraints:
                              BoxConstraints(minHeight: 17, minWidth: 20),
                          icon: Icon(Icons.close),
                          color: Color.fromRGBO(86, 86, 86, 1.0),
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            manager.closeDir(i);
                            manager.emit("CHANGE_DIR");
                          },
                        )
                      : null,
                ),
                Container(
                  width: 1,
                  color: Color.fromRGBO(200, 200, 200, 1.0),
                ),
              ],
            ),
          ),
          onTap: () {
            if (i == manager.index) return;

            manager.index = i;
            manager.emit("CHANGE_DIR");
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
          icon: Icon(Icons.add),
          onPressed: () {
            manager.openDir();
            manager.emit("CHANGE_DIR");
            setState(() {});
          },
        ),
        color: Colors.grey[300],
      ));
    }

    return Column(
      children: <Widget>[
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          color: Color.fromRGBO(154, 154, 154, 1.0),
          child: Row(
            children: tabWidgets,
          ),
        ),
        FlatButton(
            onPressed: () {
              if (manager.curPath.path != DEFAULT_PATH) {
                manager.curPath.reset(DEFAULT_PATH);
                manager.emit('CHANGE_DIR');
              }
            },
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.home),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '点击返回Home文件夹',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Spacer()
              ],
            )),
      ],
    );
  }
}
