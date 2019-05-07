import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Client {
  Client(
      {this.name,
      this.barcode,
      this.phoneNumber,
      this.time,
      this.seatNumber,
      this.isPresent});

  fill(Client client) {
    this.name = client.name;
    this.barcode = client.barcode;
    this.phoneNumber = client.phoneNumber;
    this.seatNumber = client.seatNumber;
    this.isPresent = client.isPresent;
  }

  String name;
  String barcode;
  String phoneNumber;
  DateTime time;
  int seatNumber;
  bool isPresent;
}

class ClientBuilder extends StatefulWidget {
  final Client client;

  ClientBuilder({Key key, this.client}) : super(key: key);

  @override
  _ClientBuilderState createState() => _ClientBuilderState();
}

class _ClientBuilderState extends State<ClientBuilder> {
  bool firstBuild = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final barcodeController = TextEditingController();
  final seatNumberController = TextEditingController();
  final bool isPresent = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    nameController.dispose();
    phoneController.dispose();
    barcodeController.dispose();
    seatNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var superClient = super.widget.client;
    if (firstBuild && superClient != null) {
      nameController.text = superClient.name;
      phoneController.text = superClient.phoneNumber;
      barcodeController.text = superClient.barcode;
      if (superClient.seatNumber != null) {
        seatNumberController.text = superClient.seatNumber.toString();
      }
      firstBuild = false;
    }

    void isPresentOnChanged(bool value) {
      if (superClient != null) {
        setState(() {
          superClient.isPresent = value;
        });
      }
    }

    bool getIsPresent(client) {
      if (superClient == null) {
        return true;
      } else {
        return superClient.isPresent == null ? false : superClient.isPresent;
      }
    }

    Widget getDateTimeFormat(client) {
      if (superClient == null) {
        return Text("");
      } else {
        return Text(DateFormat.Hm().format(superClient.time));
      }
    }

    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(labelText: "имя"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'телефон'),
            ),
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(labelText: 'штрих-код'),
            ),
            TextField(
              controller: seatNumberController,
              decoration: InputDecoration(labelText: 'номер места'),
            ),
            CheckboxListTile(
              value: getIsPresent(superClient),
              title: Text('присутствует'),
              subtitle: getDateTimeFormat(superClient),
              onChanged: isPresentOnChanged,
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
                            var client = Client(
                                name: nameController.text,
                                phoneNumber: phoneController.text,
                                barcode: barcodeController.text,
                                isPresent: getIsPresent(superClient),
                                seatNumber:
                                    int.tryParse(seatNumberController.text),
                                time: DateTime.now());
                            Navigator.pop(context, client);
                          }
                        },
                        child: const Text('Ok')),
                  ],
                ))
          ]))
    ]);
  }
}
