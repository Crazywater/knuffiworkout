import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';

/// An entry in the [AppDrawer].
class DrawerItem {
  /// Whether the item is currently selected.
  final bool isSelected;

  /// Whether there's a divider below the item.
  final bool hasDividerAfter;
  final IconData icon;
  final String name;
  final void Function() onTap;

  DrawerItem(this.icon, this.name,
      {@required this.onTap,
      @required this.isSelected,
      this.hasDividerAfter = false});

  Widget render() => ListTile(
        leading: Icon(icon),
        title: Text(name, style: mediumTextStyle),
        onTap: onTap,
        selected: isSelected,
      );
}

/// Left hand side drawer for the app.
class AppDrawer extends StatelessWidget {
  final List<DrawerItem> drawerItems;

  AppDrawer(this.drawerItems);

  @override
  Widget build(BuildContext context) {
    final entries = <Widget>[Padding(padding: EdgeInsets.only(top: 24.0))];
    for (final item in drawerItems) {
      entries.add(item.render());
      if (item.hasDividerAfter) {
        entries.add(Divider());
      }
    }

    return Drawer(child: ListView(children: entries));
  }
}
