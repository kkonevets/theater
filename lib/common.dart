import 'package:flutter/material.dart';
import 'package:theater/bloc.dart';
import 'package:theater/models.dart';

Widget buildStreamList(Bloc bloc, Function buildRow) {
  return StreamBuilder(
      stream: bloc.stream,
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemPosition) {
                Record rec = snapshot.data[itemPosition];
                return buildRow(rec);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          } else {
            return Container(
                child: Center(
              child: emptyListMessageWidget(),
            ));
          }
        } else {
          return Center(
            child: loadingData(bloc),
          );
        }
      });
}

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
