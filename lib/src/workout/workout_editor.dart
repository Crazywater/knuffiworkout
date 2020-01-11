import 'package:flutter/material.dart';
import 'package:knuffimap/knuffimap.dart';
import 'package:knuffimap/stream_widget.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/workout/exercise_widget.dart';

/// Editor to edit a new or existing workout.
class WorkoutEditor extends StatelessWidget {
  /// Key of the workout in the database.
  ///
  /// Can be `null` if the workout hasn't been persisted yet.
  final String _key;
  final Workout _workout;
  final bool showsSuggestion;

  WorkoutEditor(this._key, this._workout,
      {this.showsSuggestion = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      StreamWidget1(db.exercises.stream, _rebuild);

  Widget _rebuild(
      KnuffiMap<PlannedExercise> plannedExercises, BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _workout.exercises.length; i++) {
      final exercise = _workout.exercises[i];
      final widget = ExerciseWidget(
        ExerciseWrapper(exercise, plannedExercises[exercise.plannedExerciseId]),
        showsSuggestion: showsSuggestion,
        saveSet: (setIndex, set) {
          final newWorkout = _workout.rebuild((w) => w.exercises[i] =
              w.exercises[i].rebuild((e) => e.sets[setIndex] = set));
          _save(newWorkout);
        },
        saveExercise: (exercise) {
          _save(_workout.rebuild((b) => b.exercises[i] = exercise));
        },
      );
      children.add(widget);
    }

    return ListView(
      children: children,
      padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
    );
  }

  void _save(Workout newWorkout) {
    if (_key != null) {
      db.workouts.save(_key, newWorkout);
    } else {
      db.workouts.push(newWorkout);
    }
  }
}
