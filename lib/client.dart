import 'package:flutter/material.dart';

class Client {
  Client({
    this.name,
    this.barcode,
    this.phoneNumber,
    this.time,
    this.seatNumber,
    this.id,
  });

  fill(Client client) {
    this.name = client.name;
    this.barcode = client.barcode;
    this.phoneNumber = client.phoneNumber;
    this.seatNumber = client.seatNumber;
    this.name = client.name;
  }

  String name;
  String barcode;
  String phoneNumber;
  DateTime time;
  int seatNumber;
  int id;
}

class ClientBuilder extends StatefulWidget {
  final Client client;

  ClientBuilder({this.client});

  @override
  _ClientBuilderState createState() => _ClientBuilderState();
}

class _ClientBuilderState extends State<ClientBuilder> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final barcodeController = TextEditingController();
  final seatNumberController = TextEditingController();

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
    if (super.widget.client != null) {
      nameController.text = superClient.name;
      phoneController.text = superClient.phoneNumber;
      barcodeController.text = superClient.barcode;
      if (superClient.seatNumber != null) {
        seatNumberController.text = superClient.seatNumber.toString();
      }
    }
    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              autofocus: true,
              controller: nameController,
              decoration:
                  InputDecoration(border: InputBorder.none, labelText: "имя"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  border: InputBorder.none, labelText: 'телефон'),
            ),
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(
                  border: InputBorder.none, labelText: 'штрихкод'),
            ),
            TextField(
              controller: seatNumberController,
              decoration: InputDecoration(
                  border: InputBorder.none, labelText: 'номер места'),
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
