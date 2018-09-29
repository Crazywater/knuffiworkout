import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// A point in the [ProgressChart].
class ChartPoint {
  final DateTime date;
  final double value;

  ChartPoint(this.date, this.value);
}

/// A simple line chart widget.
class ProgressChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> _series;

  ProgressChart(List<ChartPoint> points) : _series = _toSeries(points);

  @override
  Widget build(BuildContext context) => charts.TimeSeriesChart(_series);
}

List<charts.Series<dynamic, DateTime>> _toSeries(List<ChartPoint> points) {
  return [
    charts.Series(
        id: 'series',
        data: points,
        domainFn: (point, _) => point.date,
        measureFn: (point, _) => point.value)
  ];
}
