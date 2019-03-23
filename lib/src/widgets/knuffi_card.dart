import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:knuffiworkout/src/widgets/colors.dart' as colors;

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
        child: Column(children: children),
      )
    ];

    final cardChild = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cardContent,
    );

    // TODO: Is there an easier way to overlay with an InkWell?
    final paint = CustomPaint(
      painter: _BorderPainter(headerHeight),
      child: onTap == null
          ? cardChild
          : Stack(children: [
              Positioned.fill(
                  top: headerHeight / 2.0,
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: onTap,
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.0))))),
              cardChild,
            ]),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: paint,
    );
  }
}

/// Paints a custom rounded-rectangle border for a card.
class _BorderPainter extends CustomPainter {
  final double headerHeight;

  _BorderPainter(this.headerHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final rect = Rect.fromPoints(
        Offset(0.0, headerHeight / 2), size.bottomRight(Offset.zero));
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(8.0));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_BorderPainter old) => old.headerHeight != headerHeight;
}
