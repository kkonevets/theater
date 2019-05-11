import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:theater/models.dart';
import 'package:theater/common.dart';

class ClientBuilder extends StatefulWidget {
  final Client client;
  final Color color;

  ClientBuilder({Key key, this.client, this.color}) : super(key: key);

  @override
  _ClientBuilderState createState() => _ClientBuilderState(client, color);
}

class _ClientBuilderState extends State<ClientBuilder> {
  final Client client;
  final Color color;

  bool isPresent = true;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final barcodeController = TextEditingController();
  final seatNumberController = TextEditingController();

  bool _hasName = false;
  String _eventName;

  _ClientBuilderState(this.client, this.color) {
    if (client != null) {
      nameController.text = client.name;
      _eventName = nameController.text;
      _hasName = true;
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
    final ThemeData theme = Theme.of(context);

    Widget getDateTimeFormat() {
      if (client == null) {
        return Text("");
      } else {
        return Text(
          DateFormat.Hm().format(client.time),
          style: theme.textTheme.subhead,
        );
      }
    }

    void _scanBarcode(BuildContext context) async {
      try {
        String barcode = await BarcodeScanner.scan();
        setState(() {
          barcodeController.text = barcode;
        });
      } on PlatformException catch (e) {
        if (e.code == BarcodeScanner.CameraAccessDenied) {
          setState(() {
            showMessage(context, "No camera permission");
          });
        } else {
          setState(() {
            showMessage(context, "Unknown error");
          });
        }
      }
    }

    Future<bool> _onWillPop() async {
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_hasName ? _eventName : 'Имя клиента'),
        backgroundColor: color,
        actions: <Widget>[
          FlatButton(
            child: Text('SAVE',
                style: theme.textTheme.body1.copyWith(color: Colors.white)),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                client.name = nameController.text;
                client.phoneNumber = phoneController.text;
                client.barcode = barcodeController.text;
                client.isPresent = isPresent;
                client.seatNumber = int.tryParse(seatNumberController.text);
                Navigator.pop(context, DismissDialogAction.save);
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (innerContext) => Form(
              onWillPop: _onWillPop,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextField(
                      controller: nameController,
//                autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Имя',
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
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'телефон',
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: TextField(
                      style: theme.textTheme.title,
                      controller: seatNumberController,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.numberWithOptions(
                          signed: false, decimal: false),
                      decoration: InputDecoration(
                        labelText: 'номер места',
                        filled: true,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.bottomLeft,
                    child: CheckboxListTile(
                      value: isPresent,
                      title: Text(
                        'присутствует',
                        style: theme.textTheme.title,
                      ),
                      subtitle: getDateTimeFormat(),
                      onChanged: (bool value) {
                        setState(() {
                          isPresent = value;
                        });
                      },
                    ),
                  ),
                  TextField(
                    controller: barcodeController,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    decoration: InputDecoration(
                        labelText: 'штрих-код',
                        suffixIcon: IconButton(
                            iconSize: 35,
                            icon: Icon(Icons.camera_alt),
                            onPressed: () => _scanBarcode(innerContext))),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
