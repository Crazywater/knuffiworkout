import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/rotation.dart' as rotation_db;
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/plan/change_list.dart';
import 'package:knuffiworkout/src/plan/day_widget.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';

/// Configuration view for the rotation.
///
/// In this view, the user configures the rotation of exercises across [Day]s.
class RotationView extends StatefulWidget {
  @override
  _RotationViewState createState() => new _RotationViewState();
}

class _RotationViewState extends State<RotationView> {
  @override
  Widget build(BuildContext context) =>
      new StreamWidget2(exercise_db.stream, workout_db.stream, _rebuild);

  Widget _rebuild(FireMap<PlannedExercise> exercises, FireMap<Workout> workouts,
      BuildContext context) {
    return new ChangeList<Day>(
      changes: rotation_db.stream,
      widgetBuilder: (context, rotation, index) => new DayWidget(
            exercises,
            rotation,
            index,
            workout_db.nextRotationIndexFor(workouts.values.toList(), rotation),
          ),
    );
  }
}
