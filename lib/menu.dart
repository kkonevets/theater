import 'package:flutter/material.dart';
import 'settings.dart';
import 'package:theater/session_list.dart';

class MenuDrawer extends StatelessWidget {
  final Function callback;

  const MenuDrawer({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Алексей Иванов"),
            accountEmail: Text("aivanov@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_movies),
            title: Text(
              'Сеаны',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SessionList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Настройки',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    SettingsBuilder(callback: callback),
              ));
            },
          ),
        ],
      ),
    );
  }
}
