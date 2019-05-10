import 'package:theater/models.dart';
import 'package:theater/database_helpers.dart';
import 'dart:async';

class Block {
  DatabaseHelper _helper = DatabaseHelper.instance;
  String tableName;
  int sessionId;

  final _controller = StreamController<List<Record>>.broadcast();

  get items => _controller.stream;

  Block({this.tableName, this.sessionId}) {
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
    await _helper.delete(rec);
    getItems();
  }

  dispose() {
    _controller.close();
  }
}
