import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'database_helpers.dart';

class ClientBuilder extends StatefulWidget {
  final Client client;

  ClientBuilder({Key key, this.client}) : super(key: key);

  @override
  _ClientBuilderState createState() => _ClientBuilderState(client);
}

class _ClientBuilderState extends State<ClientBuilder> {
  final Client client;
  bool isPresent = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final barcodeController = TextEditingController();
  final seatNumberController = TextEditingController();

  _ClientBuilderState(this.client) {
    if (client != null) {
      nameController.text = client.name;
      phoneController.text = client.phoneNumber;
      barcodeController.text = client.barcode;
      seatNumberController.text =
          client.seatNumber == null ? "" : client.seatNumber.toString();

      isPresent = client.isPresent == null ? false : client.isPresent;
    }
  }

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
    Widget getDateTimeFormat() {
      if (client == null) {
        return Text("");
      } else {
        return Text(DateFormat.Hm().format(client.time));
      }
    }

    void _scanBarcode() async {
      try {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          barcodeController.text = barcode;
        });
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            barcodeController.text = "No camera permission";
          });
        } else {
          setState(() {
            barcodeController.text = "Unknown error";
          });
        }
      }
    }

    return SimpleDialog(children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
//              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(labelText: "имя"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'телефон'),
            ),
            TextField(
              controller: barcodeController,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              decoration: InputDecoration(
                  labelText: 'штрих-код',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.camera_alt), onPressed: _scanBarcode)),
            ),
            TextField(
              controller: seatNumberController,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.numberWithOptions(
                  signed: false, decimal: false),
              decoration: InputDecoration(labelText: 'номер места'),
            ),
            CheckboxListTile(
              value: isPresent,
              title: Text('присутствует'),
              subtitle: getDateTimeFormat(),
              onChanged: (bool value) {
                setState(() {
                  isPresent = value;
                });
              },
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
                            client.name = nameController.text;
                            client.phoneNumber = phoneController.text;
                            client.barcode = barcodeController.text;
                            client.isPresent = isPresent;
                            client.seatNumber =
                                int.tryParse(seatNumberController.text);

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
