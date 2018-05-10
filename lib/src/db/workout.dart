import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/db/rotation.dart' as rotation_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:rxdart/rxdart.dart';

final DatabaseReference _db = userDb.child('done');

final _adapter = new FirebaseAdapter<Workout>(
    _db, (e) => new Workout.fromJson(e),
    comparator: (w1, w2) => w2.date.compareTo(w1.date));

Observable<FireMap<Workout>> get stream => _adapter.stream;

Future<Null> initialize() => _adapter.open();

/// Returns the workout at the given day.
///
/// If no such workout exists yet, creates a new one.
Future<Workout> create(DateTime date) async {
  final plannedExercises = await exercise_db.stream.first;
  final rotation = (await rotation_db.stream.first).values.toList();
  final rotationIndex = await nextRotationIndex();
  final plan = rotation[rotationIndex];

  final workout = new WorkoutBuilder()
    ..rotationIndex = rotationIndex
    ..date = date.millisecondsSinceEpoch;

  for (final id in plan.plannedExerciseIds) {
    final lastExercise = await _getLastExercise(id);

    final exercise = new ExerciseBuilder()
      ..plannedExerciseId = id
      ..weight = lastExercise?.weight ?? 0.0
      ..suggestion = _computeSuggestion(lastExercise, plannedExercises);
    for (final plannedSet in plannedExercises[id].sets) {
      exercise.sets.add(new WorkoutSet((b) => b
        ..completed = false
        ..plannedReps = plannedSet.reps
        ..actualReps = 0));
    }
    workout.exercises.add(exercise.build());
  }

  return workout.build();
}

double _computeSuggestion(
    Exercise lastExercise, FireMap<PlannedExercise> plannedExercises) {
  final lastWeight = lastExercise?.weight ?? 0.0;
  if (lastWeight == 0.0) return lastWeight;

  var suggestion = lastExercise.weight;

  bool shouldIncrease =
      lastExercise.sets.every((set) => set.actualReps >= set.plannedReps);
  bool shouldDoubleIncrease = shouldIncrease &&
      lastExercise.sets.last.actualReps >=
          2 * lastExercise.sets.last.plannedReps;

  final plan = plannedExercises[lastExercise.plannedExerciseId];

  if (shouldIncrease) {
    suggestion += plan.increase;
    if (shouldDoubleIncrease) {
      suggestion += plan.increase;
    }
  } else {
    suggestion *= (1.0 - plan.decreaseFactor);
  }

  return suggestion;
}

Future<int> nextRotationIndex() async {
  final workouts = (await stream.first).values.toList();
  final rotation = (await rotation_db.stream.first).values.toList();
  return nextRotationIndexFor(workouts, rotation);
}

int nextRotationIndexFor(List<Workout> workouts, List<Day> rotation) {
  if (workouts.isEmpty) return 0;
  return (workouts.first.rotationIndex + 1) % rotation.length;
}

Future save(Workout workout) async {
  await _getEntry(workout.dateTime).set(workout.toJson());
}

Future<Exercise> _getLastExercise(String exerciseId) async {
  final workouts = await stream.first;
  for (final workout in workouts.values) {
    for (final exercise in workout.exercises) {
      if (exercise.plannedExerciseId == exerciseId) {
        return exercise;
      }
    }
  }
  return null;
}

DatabaseReference _getEntry(DateTime date) => _db.child(toKey(date));

String toKey(DateTime d) => '${d.year}-${_padDate(d.month)}-${_padDate(d.day)}';

String _padDate(int date) => date.toString().padLeft(2, '0');
