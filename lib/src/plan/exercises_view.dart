import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/plan/change_list.dart';
import 'package:knuffiworkout/src/plan/exercise_widget.dart';

/// A view where the user defines their [PlannedExercise]s, i.e. what type
/// of exercises they want to perform (name, sets, reps, weighted, ...).
class PlanExercisesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeList<PlannedExercise>(
      changes: db.exercises.stream,
      widgetBuilder: (context, exercises, index) =>
          ExerciseWidget(exercises[index]));
}
