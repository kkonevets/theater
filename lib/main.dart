import 'package:flutter/material.dart';

import 'package:theater/session_list.dart';
import 'package:theater/init_test.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SessionList());
  }
}

void main() async {
  await initializeTestData();

  runApp(MyApp());
}
