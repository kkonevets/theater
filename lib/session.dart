import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theater/models.dart';

class SessionBuilder extends StatefulWidget {
  final Session session;

  SessionBuilder({Key key, this.session}) : super(key: key);

  @override
  _SessionBuilderState createState() => _SessionBuilderState(session);
}

class _SessionBuilderState extends State<SessionBuilder> {
  final Session session;
  final nameController = TextEditingController();
  final totalSeatsController = TextEditingController();

  _SessionBuilderState(this.session) {
    if (session != null) {
      nameController.text = session.name;
      totalSeatsController.text =
          session.totalSeats == null ? "" : session.totalSeats.toString();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    totalSeatsController.dispose();
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
              controller: nameController,
              decoration: InputDecoration(labelText: 'Имя сеанса'),
            ),
            TextFormField(
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              controller: totalSeatsController,
              decoration: InputDecoration(labelText: 'количество мест'),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Отмена')),
                    RaisedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            session.name = nameController.text;
                            session.totalSeats =
                                int.tryParse(totalSeatsController.text);

                            Navigator.of(context).pop(true);
                          }
                        },
                        child: const Text('Ok')),
                  ],
                ))
          ]))
    ]);
  }
}
