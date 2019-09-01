import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/widgets/rounded_rectangle.dart';
import 'package:meta/meta.dart';

/// A Knufficard specific styled card.
///
/// This card draws a header on top of a rounded rectangle, and contents
/// inside that rectangle.
class KnuffiCard extends StatelessWidget {
  final Widget header;
  final double headerHeight;
  final List<Widget> children;
  final GestureTapCallback onTap;

  KnuffiCard(
      {@required this.header,
      @required this.children,
      this.onTap,
      this.headerHeight = 26.0});

  @override
  Widget build(BuildContext context) {
    final cardContent = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: header,
      ),
      Padding(
        padding:
            EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0, bottom: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      )
    ];

    final cardChild = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cardContent,
    );

    final rectangle = RoundedRectangle(
      onTap: onTap,
      headerHeight: headerHeight,
      strokeColor: borderColor,
      child: cardChild,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: rectangle,
    );
  }
}
