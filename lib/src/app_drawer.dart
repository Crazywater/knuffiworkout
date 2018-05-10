import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';
import 'package:meta/meta.dart';

/// An entry in the app drawer.
class DrawerItem {
  /// Whether the item is currently selected.
  final bool isSelected;

  /// Whether there's a divider below the item.
  final bool hasDividerAfter;
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  DrawerItem(this.icon, this.name,
      {@required this.onTap,
      @required this.isSelected,
      this.hasDividerAfter = false});

  Widget render() => new ListTile(
        leading: new Icon(icon),
        title: new Text(name, style: mediumTextStyle),
        onTap: onTap,
        selected: isSelected,
      );
}

class AppDrawer extends StatelessWidget {
  final List<DrawerItem> drawerItems;

  AppDrawer(this.drawerItems);

  @override
  Widget build(BuildContext context) {
    final entries = <Widget>[
      new Padding(padding: new EdgeInsets.only(top: 24.0))
    ];
    for (final item in drawerItems) {
      entries.add(item.render());
      if (item.hasDividerAfter) {
        entries.add(new Divider());
      }
    }

    return new Drawer(child: new ListView(children: entries));
  }
}
