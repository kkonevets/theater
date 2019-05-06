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
