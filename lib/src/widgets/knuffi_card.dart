import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knuffiworkout/src/widgets/padding.dart';
import 'package:meta/meta.dart';

/// A wrapper around [Card] with Knuffiworkout specific styling.
class KnuffiCard extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  final GestureTapCallback onTap;

  KnuffiCard({this.header, @required this.children, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = <Widget>[];
    if (header != null) {
      content..add(header)..add(headerSeparator);
    }
    content.addAll(children);

    Widget cardChild = new Padding(
      padding: cardPadding,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );

    if (onTap != null) {
      cardChild = new InkWell(onTap: onTap, child: cardChild);
    }

    return new Card(child: cardChild);
  }
}
