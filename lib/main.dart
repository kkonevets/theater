import 'package:flutter/material.dart';

import 'package:theater/session_list.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SessionList());
  }
}

void main() async {
  runApp(MyApp());
}
