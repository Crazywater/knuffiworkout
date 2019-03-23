import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Makes a widget non-transparent by adding a canvas color background.
///
/// This is useful for widgets that are overlaid over the KnuffiCard border.
class Intransparent extends StatelessWidget {
  final Widget child;

  const Intransparent(this.child, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: child,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ));
  }
}
