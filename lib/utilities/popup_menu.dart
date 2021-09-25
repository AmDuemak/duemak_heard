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
            leading: Icon(Icons.add),
            title: Text('Item 1'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete_forever),
            title: Text('Delete file'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
          ),
        ),
      ],
    );
  }
}
