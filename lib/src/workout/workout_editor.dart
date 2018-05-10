import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:knuffiworkout/src/workout/exercise_widget.dart';

/// Editor to edit a new or existing workout.
class WorkoutEditor extends StatelessWidget {
  final Workout _workout;
  final bool showsSuggestion;

  WorkoutEditor(this._workout, {this.showsSuggestion = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      new StreamWidget1(exercise_db.stream, _rebuild);

  Widget _rebuild(
      FireMap<PlannedExercise> plannedExercises, BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _workout.exercises.length; i++) {
      final exercise = _workout.exercises[i];
      final widget = new ExerciseWidget(
        new ExerciseWrapper(
            exercise, plannedExercises[exercise.plannedExerciseId]),
        showsSuggestion: showsSuggestion,
        saveSet: (setIndex, set) {
          final newWorkout = _workout.rebuild((w) => w.exercises[i] =
              w.exercises[i].rebuild((e) => e.sets[setIndex] = set));
          workout_db.save(newWorkout);
        },
        saveExercise: (exercise) {
          workout_db.save(_workout.rebuild((b) => b.exercises[i] = exercise));
        },
      );
      children.add(widget);
    }

    return new ListView(children: children);
  }
}
