import 'package:theater/models.dart';
import 'package:theater/database_helpers.dart';
import 'dart:async';

/*
Business Logic Component Architecture Design Pattern
*/
class Bloc {
  DatabaseHelper _helper = DatabaseHelper.instance;
  String tableName;
  int sessionId;

  final _controller = StreamController<List<Record>>.broadcast();

  get stream => _controller.stream;

  Bloc({this.tableName, this.sessionId}) {
    getItems();
  }

  getItems() async {
    List<Record> result = await _helper.getAll(tableName, sessionId: sessionId);
    _controller.sink.add(result);
  }

  add(Record rec) async {
    await _helper.insert(rec);
    getItems();
  }

  update(Record rec) async {
    await _helper.update(rec);
    getItems();
  }

  delete(Record rec) async {
    _helper.delete(rec);
    getItems();
  }

  dispose() {
    _controller.close();
  }
}
