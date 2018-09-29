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

    Widget cardChild = Padding(
      padding: cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );

    if (onTap != null) {
      cardChild = InkWell(onTap: onTap, child: cardChild);
    }

    return Card(child: cardChild);
  }
}
