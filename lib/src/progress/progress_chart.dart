import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';

/// A point in the [ProgressChart].
class ChartPoint {
  final DateTime date;
  final double value;

  ChartPoint(this.date, this.value);
}

/// A simple line chart widget.
class ProgressChart extends StatelessWidget {
  final List<ChartPoint> points;

  ProgressChart(this.points);

  @override
  Widget build(BuildContext context) =>
      new CustomPaint(painter: new ChartPainter(points));
}

/// [CustomPainter] to draw the [ProgressChart].
class ChartPainter extends CustomPainter {
  /// Actual data points.
  final List<ChartPoint> entries;

  ChartPainter(this.entries);

  /// Start of the drawing area.
  double _xMin;

  /// Width of the drawing area (without labels).
  double _width;

  /// Height of the drawing area (without labels).
  double _height;

  int _dataMin;
  int _dataMax;

  @override
  bool shouldRepaint(ChartPainter old) => true;

  @override
  void paint(Canvas canvas, Size size) {
    _xMin = _fontBoxSize;
    _width = size.width - _fontBoxSize;
    _height = size.height - (_fontBoxSize / 2);

    _dataMin = entries.map((entry) => entry.value).reduce(math.min).floor();
    _dataMax = entries.map((entry) => entry.value).reduce(math.max).ceil();

    _drawLines(canvas, size);
    _drawData(canvas);
  }

  void _drawLines(Canvas canvas, Size size) {
    final paint = new Paint()..color = underlineColor;
    final labelIncrement =
        math.max((_dataMax - _dataMin) ~/ (_lineCount - 1), 1);
    final yOffsetDecrement = _height / (_lineCount - 1);
    for (var yOffset = _height, label = _dataMin;
        label <= _dataMax;
        yOffset -= yOffsetDecrement, label += labelIncrement) {
      _drawLabel(label, canvas, yOffset);
      canvas.drawLine(
        new Offset(_xMin, yOffset),
        new Offset(size.width, yOffset),
        paint,
      );
    }
  }

  void _drawLabel(int label, ui.Canvas canvas, double yOffset) {
    final style = new ui.ParagraphStyle(
      fontSize: _fontSize,
      textAlign: TextAlign.right,
    );
    final builder = new ui.ParagraphBuilder(style)
      ..pushStyle(new ui.TextStyle(color: Colors.black))
      ..addText('$label');
    final paragraph = builder.build()
      ..layout(new ui.ParagraphConstraints(width: (_xMin - _fontPadding)));
    canvas.drawParagraph(paragraph, new Offset(0.0, yOffset - (_fontSize / 2)));
  }

  void _drawData(ui.Canvas canvas) {
    final paint = new Paint()
      ..color = primarySwatch
      ..strokeWidth = 3.0;

    for (var i = 0; i < entries.length - 1; i++) {
      final start = _getOffset(entries[i]);
      final end = _getOffset(entries[i + 1]);
      canvas.drawLine(start, end, paint);
    }
  }

  Offset _getOffset(ChartPoint entry) {
    final xIndex = entries.indexOf(entry);
    final xOffset = _xMin + xIndex / (entries.length - 1) * _width;
    final relativeY = _dataMin == _dataMax
        ? 0.0
        : (entry.value - _dataMin) / (_dataMax - _dataMin);
    final yOffset = _height - relativeY * _height;
    return new Offset(xOffset, yOffset);
  }
}

/// Number of horizontal lines.
const _lineCount = 5;

/// Font size of the labels.
const _fontSize = 14.0;

/// Box size of the layout surrounding the box.
const _fontBoxSize = 24.0;

/// Padding between label and line.
const _fontPadding = 8.0;
