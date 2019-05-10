//import 'package:theater/models.dart';
//import 'package:theater/database_helpers.dart';
//import 'dart:async';
//
//class Block {
//  DatabaseHelper _helper = DatabaseHelper.instance;
//  String tableName;
//
//  final _controller = StreamController<List<Record>>.broadcast();
//
//  get items => _controller.stream;
//
//  Block({this.tableName});
//
//  getList({int sessionId}) async {
//    List<Record> result = await _helper.getAll(tableName, sessionId: sessionId);
//    _controller.sink.add(result);
//  }
//
//  add(Record rec) async {
//    await _helper.insert(rec);
//    getList();
//  }
//
//  update(Record rec) async {
//    await _helper.update(rec);
//    getList();
//  }
//
//  deleteById(int id) async {
//    _helper.deleteById(id);
//    getList();
//  }
//
//  dispose() {
//    _controller.close();
//  }
//}
