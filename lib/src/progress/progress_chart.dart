import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:knuffiworkout/src/progress/progress_measure.dart';

/// A point in the [ProgressChart].
class ChartPoint {
  final DateTime date;
  final double value;

  ChartPoint(this.date, this.value);
}

/// A simple line chart widget.
class ProgressChart extends StatelessWidget {
  final List<charts.Series<ChartPoint, DateTime>> _series;

  ProgressChart(this._series);

  @override
  Widget build(BuildContext context) =>
      OrientationBuilder(builder: _buildChart);

  Widget _buildChart(BuildContext context, Orientation orientation) {
    final legendPosition = orientation == Orientation.landscape
        ? charts.BehaviorPosition.start
        : charts.BehaviorPosition.top;
    return charts.TimeSeriesChart(_series, behaviors: [
      charts.SeriesLegend(position: legendPosition, horizontalFirst: false)
    ]);
  }
}

/// Creates a charts_flutter [charts.Series] for a line in the chart.
charts.Series<ChartPoint, DateTime> createSeries(
        ProgressMeasure measure, List<ChartPoint> points) =>
    charts.Series<ChartPoint, DateTime>(
        id: measure.name,
        data: points,
        domainFn: (point, _) => point.date,
        measureFn: (point, _) => point.value);
