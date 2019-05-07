import 'package:flutter/material.dart';
import 'session.dart';

class SessionBuilder extends StatefulWidget {
  final Session session;

  SessionBuilder({Key key, this.session}) : super(key: key);

  @override
  _SessionBuilderState createState() => _SessionBuilderState();
}

class _SessionBuilderState extends State<SessionBuilder> {
  bool firstBuild = true;
  final nameController = TextEditingController();
  final totalSeatsController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    totalSeatsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var superSession = super.widget.session;
    if (firstBuild && superSession != null) {
      nameController.text = superSession.name;
      totalSeatsController.text = superSession.totalSeats.toString();
      firstBuild = false;
    }

    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(labelText: 'Имя сеанса'),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: totalSeatsController,
              decoration: InputDecoration(labelText: 'количество мест'),
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
                          if (nameController.text.isNotEmpty) {
                            var session = Session(
                              name: nameController.text,
                              totalSeats: int.parse(totalSeatsController.text),
                              time: superSession == null
                                  ? DateTime.now()
                                  : superSession.time,
                            );
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
