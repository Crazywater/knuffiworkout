import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/progress/progress_chart.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';

/// Shows the progress over time.
class ProgressView extends StatefulWidget {
  ProgressView({Key key}) : super(key: key);

  @override
  _ProgressViewState createState() => new _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  /// Currently selected exercise id.
  String _exerciseId;

  @override
  Widget build(BuildContext context) =>
      new StreamWidget2(workout_db.stream, exercise_db.stream, _rebuild);

  Widget _rebuild(FireMap<Workout> workouts, FireMap<PlannedExercise> exercises,
      BuildContext context) {
    List<String> exerciseIds =
        exercises.keys.where((id) => exercises[id].hasWeight).toList();
    exerciseIds.sort(
        (left, right) => exercises[left].name.compareTo(exercises[right].name));
    if (!exerciseIds.contains(_exerciseId)) {
      _exerciseId = exerciseIds.first;
    }

    final workoutList = workouts.values.toList();

    final dataPoints = <ChartPoint>[];
    for (final workout in workoutList.reversed) {
      for (final exercise in workout.exercises) {
        if (exercise.plannedExerciseId != _exerciseId) continue;
        final reps = exercise.sets.last.actualReps;
        if (reps == 0) continue;
        final weight = exercise.weight;
        final oneRepMax = _predictOneRepMax(reps, weight);
        dataPoints.add(new ChartPoint(workout.dateTime, oneRepMax));
      }
    }

    return new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new Row(children: [
            new DropdownButton<String>(
                items: exerciseIds
                    .map((id) => new DropdownMenuItem(
                          value: id,
                          child: new Text(exercises[id].name),
                        ))
                    .toList(),
                onChanged: (exerciseId) {
                  setState(() {
                    _exerciseId = exerciseId;
                  });
                },
                value: _exerciseId),
          ]),
          new Expanded(
              child: new Padding(
                  padding: new EdgeInsets.all(16.0),
                  child: dataPoints.isEmpty
                      ? new Text('No data yet')
                      : new ProgressChart(dataPoints))),
        ]);
  }
}

/// Factors to translate n reps of some weight into the one rep max.
final _repsToOneRepMax = [
  1,
  .95,
  .93,
  .90,
  .87,
  .85,
  .83,
  .80,
  .77,
  .75,
  .72,
  .67
];

double _predictOneRepMax(int reps, double weight) {
  final index = min(reps - 1, _repsToOneRepMax.length - 1);
  return weight / _repsToOneRepMax[index];
}
