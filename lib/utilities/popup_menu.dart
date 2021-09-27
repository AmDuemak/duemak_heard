import 'package:flutter/material.dart';

class ThePopupMneu extends StatelessWidget {
  const ThePopupMneu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete offline files'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & feedback'),
          ),
        ),
      ],
    );
  }
}
