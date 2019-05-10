import 'package:flutter/material.dart';

import 'package:theater/session_list.dart';
import 'package:theater/init_test.dart';
import 'package:theater/database_helpers.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SessionList());
  }
}

void main() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  if (!await helper.dbExists()) {
    await initializeTestData();
  }

  runApp(MyApp());
}
