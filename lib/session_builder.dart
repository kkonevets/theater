import 'package:flutter/material.dart';
import 'session.dart';

class SessionBuilder extends StatefulWidget {
  @override
  _SessionBuilderState createState() => _SessionBuilderState();
}

class _SessionBuilderState extends State<SessionBuilder> {
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              autofocus: true,
              controller: myController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Введите название сеанса'),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Отмена')),
                    RaisedButton(
                        onPressed: () {
                          if (myController.text.isNotEmpty) {
                            Session session = Session(
                                name: myController.text,
                                time: TimeOfDay(hour: 10, minute: 20));
                            Navigator.pop(context, session);
                          }
                        },
                        child: const Text('Ok')),
                  ],
                ))
          ]))
    ]);
  }
}
