import 'package:flutter/material.dart';
import 'package:theater/session_list.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key key,
  }) : super(key: key);

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
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
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
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => NewPage("Page two")));
            },
          ),
        ],
      ),
    );
  }
}
