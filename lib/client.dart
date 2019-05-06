import 'package:flutter/material.dart';

class Client {
  Client({
    this.name,
    this.barcode,
    this.phoneNumber,
    this.time,
    this.seatNumber,
  });

  String name;
  String barcode;
  String phoneNumber;
  DateTime time;
  int seatNumber;
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
    nameController.text = super.widget.client.name;
    phoneController.text = super.widget.client.phoneNumber;
    barcodeController.text = super.widget.client.barcode;
    seatNumberController.text ??= super.widget.client.seatNumber.toString();

    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              autofocus: true,
              controller: nameController,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: 'имя'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'телефон'),
            ),
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'штрихкод'),
            ),
            TextField(
              controller: seatNumberController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'номер места'),
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
