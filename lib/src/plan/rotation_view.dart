import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/plan/change_list.dart';
import 'package:knuffiworkout/src/plan/day_widget.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';

/// Configuration view for the rotation.
///
/// In this view, the user configures the rotation of exercises across [Day]s.
class RotationView extends StatefulWidget {
  @override
  _RotationViewState createState() => _RotationViewState();
}

class _RotationViewState extends State<RotationView> {
  @override
  Widget build(BuildContext context) =>
      StreamWidget2(db.exercises.stream, db.workouts.stream, _rebuild);

  Widget _rebuild(FireMap<PlannedExercise> exercises, FireMap<Workout> workouts,
      BuildContext context) {
    return ChangeList<Day>(
      changes: db.rotation.stream,
      widgetBuilder: (context, rotation, index) => DayWidget(
            exercises,
            rotation,
            index,
            db.workouts
                .nextRotationIndexFor(workouts.values.toList(), rotation),
          ),
    );
  }
}
