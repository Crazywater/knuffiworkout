import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Draws a rounded rectangle, optionally clickable.
class RoundedRectangle extends StatelessWidget {
  /// Height of the header.
  ///
  /// This can be used to overlay a header with the top border of the rounded
  /// rectangle.
  final double headerHeight;

  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;
  final Color strokeColor;
  final Color fillColor;
  final Widget child;

  const RoundedRectangle(
      {Key key,
      this.onTap,
      this.onLongPress,
      this.headerHeight = 0,
      this.strokeColor,
      this.fillColor,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Is there an easier way to overlay with an InkWell?
    return CustomPaint(
      painter: _BorderPainter(
        headerHeight,
        strokeColor: strokeColor,
        fillColor: fillColor,
      ),
      child: onTap == null && onLongPress == null
          ? child
          : Stack(children: [
              child,
              Positioned.fill(
                  top: headerHeight / 2.0,
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: onTap,
                          onLongPress: onLongPress,
                          borderRadius:
                              BorderRadius.all(Radius.circular(8.0))))),
            ]),
    );
  }
}

/// Paints a custom rounded-rectangle border.
class _BorderPainter extends CustomPainter {
  final double headerHeight;
  final Color strokeColor;
  final Color fillColor;

  _BorderPainter(this.headerHeight, {this.strokeColor, this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromPoints(
        Offset(0.0, headerHeight / 2), size.bottomRight(Offset.zero));
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(8.0));

    if (strokeColor != null) {
      final strokePaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(rrect, strokePaint);
    }

    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_BorderPainter old) =>
      old.headerHeight != headerHeight ||
      old.strokeColor != strokeColor ||
      old.fillColor != fillColor;
}
