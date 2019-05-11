import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theater/models.dart';
import 'package:theater/common.dart';

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
  DateTime _fromDateTime = DateTime.now();
  bool _saveNeeded = false;

  bool _hasName = false;
  String _eventName;

  _SessionBuilderState(this.session) {
    if (session != null) {
      nameController.text = session.name;
      _eventName = nameController.text;
      _hasName = true;
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

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasName ? _eventName : 'Имя сеанса'),
        actions: <Widget>[
          FlatButton(
            child: Text('SAVE',
                style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                session.name = nameController.text;
                session.totalSeats = int.tryParse(totalSeatsController.text);

                Navigator.pop(context, DismissDialogAction.save);
              }
            },
          ),
        ],
      ),
      body: Form(
        onWillPop: _onWillPop,
        child: ListView(padding: const EdgeInsets.all(16.0), children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.bottomLeft,
            child: TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Имя сеанса',
                filled: true,
              ),
              style: theme.textTheme.title,
              onChanged: (String value) {
                setState(() {
                  _hasName = value.isNotEmpty;
                  if (_hasName) {
                    _eventName = value;
                  }
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.bottomLeft,
            child: TextFormField(
              style: theme.textTheme.title,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              controller: totalSeatsController,
              decoration: InputDecoration(
                labelText: 'количество мест',
                filled: true,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('From', style: theme.textTheme.caption),
              DateTimeItem(
                dateTime: _fromDateTime,
                onChanged: (DateTime value) {
                  setState(() {
                    _fromDateTime = value;
                    _saveNeeded = true;
                  });
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
