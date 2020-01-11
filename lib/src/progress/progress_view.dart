import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:knuffimap/knuffimap.dart';
import 'package:knuffimap/stream_widget.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/progress/progress_chart.dart';
import 'package:knuffiworkout/src/progress/progress_measure.dart';

/// Shows the progress over time.
class ProgressView extends StatefulWidget {
  ProgressView({Key key}) : super(key: key);

  @override
  _ProgressViewState createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  /// The selected exercise.
  ///
  /// `null` if the user hasn't selected any yet.
  String _exerciseId;

  @override
  Widget build(BuildContext context) =>
      StreamWidget2(db.workouts.stream, db.exercises.stream, _rebuild);

  Widget _rebuild(KnuffiMap<Workout> workouts,
      KnuffiMap<PlannedExercise> exercises, BuildContext context) {
    final exerciseIds = exercises.keys.toList();
    exerciseIds.sort(
        (left, right) => exercises[left].name.compareTo(exercises[right].name));

    final selectedExercise = exercises[_exerciseId ?? exerciseIds.first];
    final workoutList = workouts.values.toList();

    final availableMeasures = selectedExercise.hasWeight
        ? ProgressMeasure.all
        : ProgressMeasure.unweighted;

    final series = <charts.Series<ChartPoint, DateTime>>[];
    for (final measure in availableMeasures) {
      final points = <ChartPoint>[];
      for (final workout in workoutList.reversed) {
        final matchingExercises = workout.exercises
            .where((e) => e.plannedExerciseId == selectedExercise.id);
        final measures = matchingExercises.map(measure.function);
        points.addAll(measures
            .where((measure) => measure != null)
            .map((measure) => ChartPoint(workout.dateTime, measure)));
      }
      series.add(createSeries(measure, points));
    }

    final exerciseSelector = Container(
      width: 200,
      child: DropdownButton<String>(
          isExpanded: true,
          items: exerciseIds
              .map((id) => DropdownMenuItem(
                    value: id,
                    child: Text(
                      exercises[id].name,
                    ),
                  ))
              .toList(),
          onChanged: (exerciseId) {
            setState(() {
              _exerciseId = exerciseId;
            });
          },
          value: selectedExercise.id),
    );

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: exerciseSelector,
            )
          ],
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(16.0), child: ProgressChart(series))),
      ],
    );
  }
}
