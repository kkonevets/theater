import 'package:flutter/material.dart';

class SettingsBuilder extends StatefulWidget {
  SettingsBuilder({Key key}) : super(key: key);

  @override
  _SettingsBuilderState createState() => _SettingsBuilderState();
}

class _SettingsBuilderState extends State<SettingsBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Настройки"),
        ),
        body: Center(
          child: RaisedButton.icon(
            icon: Icon(Icons.sync),
            label: const Text('Синхронизировать'),
            onPressed: () => {},
          ),
        ));
  }
}
