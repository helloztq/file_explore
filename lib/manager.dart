import 'dart:ffi';

const String DEFAULT_PATH = "/storage/emulated/0/";

typedef void EventCallback(dynamic arg);

class PathInfo {
  String _path;
  List<String> _subNames;

  PathInfo(String path) {
    reset(path);
  }

  List<String> get subNames => _subNames;

  String get path => _path;

  String subPath(int idx) {
    var t = _subNames.sublist(0, idx);

    String ret = "";
    for (int i = 0; i < t.length; ++i) {
      if (t[i] != "/") {
        ret = ret + t[i] + "/";
      } else {
        ret = ret + "/";
      }
    }
    return ret;
  }

  void reset(String path) {
    assert(path != null && path.length > 0, "Error:updatePath&path is null");
    _path = path;

    _subNames = path.split('/');

    if (_subNames.length > 0 && _subNames[0].length == 0) {
      _subNames.removeAt(0);
    }

    if (_subNames.length > 0 && _subNames[_subNames.length - 1].length == 0) {
      _subNames.removeAt(_subNames.length - 1);
    }

    if (path[0] == "/") {
      _subNames.insert(0, "/");
    }
  }
}

class FileManager {
  List<PathInfo> _openList = [];
  List<String> _copyFiles = [];

  int _curIndex = 0;
  var _event = Map<String, List<EventCallback>>();

  static FileManager _instance = FileManager._internal();

  FileManager._internal() {
    _openList.add(PathInfo(DEFAULT_PATH));
    // _list.add(DEFAULT_PATH);
  }

  factory FileManager() {
    return _instance;
  }

  static FileManager instance() {
    return _instance;
  }

  List<PathInfo> get dirs => _openList;

  int get length => _openList.length;

  int get index => _curIndex;

  PathInfo get curPath => _openList[_curIndex];

  List<String> get copyFiles => _copyFiles;

  set curPath(s) => _openList[_curIndex] = s;

  set index(idx) => _curIndex = idx;

  void addCopyFile(String path) {
    if (!_copyFiles.contains(path)) _copyFiles.add(path);
  }

  void removeCopyFile(String path) {
    _copyFiles.remove(path);
  }

  void closeDir(int index) {
    if (_openList.length > 1) {
      _openList.removeAt(index);

      _curIndex = _curIndex - 1;

      if (_curIndex < 0) {
        _curIndex = 0;
      }
    }
  }

  void openDir() {
    _openList.add(PathInfo(DEFAULT_PATH));
    _curIndex = _openList.length - 1;
  }

  void on(eventName, EventCallback f) {
    if (eventName == null || f == null) return;
    _event[eventName] ??= List<EventCallback>();
    _event[eventName].add(f);
  }

  void off(eventName, [EventCallback f]) {
    var list = _event[eventName];
    if (eventName == null || list == null) return;

    if (f == null) {
      _event[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  void emit(eventName, [arg]) {
    var list = _event[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }
}

var gManager = FileManager();
