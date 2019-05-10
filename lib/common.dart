import 'package:flutter/material.dart';
import 'package:theater/bloc.dart';

Widget loadingData(Bloc bloc) {
  bloc.getItems();
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Text("Loading...",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
        ],
      ),
    ),
  );
}

Widget emptyListMessageWidget() {
  return Container(
    child: Text(
      "Начните добавлять ...",
      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
    ),
  );
}

