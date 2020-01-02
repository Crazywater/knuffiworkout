import 'dart:async';

import 'package:knuffiworkout/src/db/exercise.dart';
import 'package:knuffiworkout/src/db/map_adapter.dart';
import 'package:knuffiworkout/src/db/rotation.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';
import 'package:rxdart/rxdart.dart';

/// Workouts performed by the user.
class WorkoutDb {
  final Reference _db;
  final ExerciseDb _exerciseDb;
  final RotationDb _rotationDb;
  final MapAdapter<Workout> _adapter;

  WorkoutDb(this._db, this._exerciseDb, this._rotationDb)
      : _adapter = MapAdapter<Workout>(_db, (e) => Workout.fromJson(e),
            comparator: (w1, w2) => w2.date.compareTo(w1.date));

  Observable<FireMap<Workout>> get stream => _adapter.stream;

  /// Initializes the workout database.
  ///
  /// Must be called once before accessing [stream].
  Future<void> initialize() => _adapter.open();

  /// Creates a new workout at the given day.
  ///
  /// This workout is not yet persisted to the database. To persist it, call
  /// [push].
  Future<Workout> create(DateTime date) async {
    final plannedExercises = await _exerciseDb.stream.first;
    final rotation = (await _rotationDb.stream.first).values.toList();
    final rotationIndex = await nextRotationIndex();
    final plan = rotation[rotationIndex];

    final workout = WorkoutBuilder()
      ..rotationIndex = rotationIndex
      ..date = date.millisecondsSinceEpoch;

    for (final id in plan.plannedExerciseIds) {
      final lastExercise = await _lastExercise(id);

      final exercise = ExerciseBuilder()
        ..plannedExerciseId = id
        ..weight = lastExercise?.weight ?? 0.0
        ..suggestion = _computeSuggestion(lastExercise, plannedExercises);
      for (final plannedSet in plannedExercises[id].sets) {
        exercise.sets.add(WorkoutSet((b) => b
          ..completed = false
          ..plannedReps = plannedSet.reps
          ..actualReps = 0));
      }
      workout.exercises.add(exercise.build());
    }

    return workout.build();
  }

  /// Computes the suggested weight, given the last exercise of that type.
  ///
  /// [lastExercise] may be null if there is none.
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

  /// Index in the rotation of the next workout (the next day).
  Future<int> nextRotationIndex() async {
    final workouts = (await stream.first).values.toList();
    final rotation = (await _rotationDb.stream.first).values.toList();
    return nextRotationIndexFor(workouts, rotation);
  }

  /// Index in the [rotation] for the next workout, given that [workouts] are
  /// sorted by date (newest one first).
  int nextRotationIndexFor(List<Workout> workouts, List<Day> rotation) {
    if (workouts.isEmpty) return 0;
    return (workouts.first.rotationIndex + 1) % rotation.length;
  }

  /// Persists a new [Workout] to the database.
  Future<void> push(Workout workout) => _db.push().set(workout.toJson());

  /// Updates an existing [Workout].
  Future<void> save(String key, Workout workout) =>
      _db.child(key).set(workout.toJson());

  /// Deletes a [Workout].
  Future<void> delete(String key) => _db.child(key).remove();

  /// Returns the most recently performed [Exercise] of the given ID.
  Future<Exercise> _lastExercise(String exerciseId) async {
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
}
