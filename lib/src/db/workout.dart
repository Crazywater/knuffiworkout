import 'dart:async';

import 'package:knuffimap/knuffimap.dart';
import 'package:knuffimap/reference.dart';
import 'package:knuffiworkout/src/db/exercise.dart';
import 'package:knuffiworkout/src/db/rotation.dart';
import 'package:knuffiworkout/src/model.dart';

/// Workouts performed by the user.
class WorkoutDb {
  final Reference _db;
  final ExerciseDb _exerciseDb;
  final RotationDb _rotationDb;
  final MapAdapter<Workout> _adapter;

  WorkoutDb(this._db, this._exerciseDb, this._rotationDb)
      : _adapter = MapAdapter<Workout>(_db, (e) => Workout.fromJson(e),
            comparator: (w1, w2) => w2.date.compareTo(w1.date));

  Stream<KnuffiMap<Workout>> get stream => _adapter.stream;

  /// Initializes the workout database.
  ///
  /// Must be called once before accessing [stream].
  Future<void> initialize() => _adapter.open();

  /// Creates a new workout at the given day.
  ///
  /// This workout is not yet persisted to the database. To persist it, call
  /// [push].
  Future<Workout> create(DateTime date) async {
    final allExercises = await _exerciseDb.stream.first;
    final rotation = (await _rotationDb.stream.first).values.toList();
    final rotationIndex = await nextRotationIndex();
    final plan = rotation[rotationIndex];

    final exercises = await Future.wait(
        plan.plannedExerciseIds.map((id) => _instantiate(id, allExercises)));

    final workout = WorkoutBuilder()
      ..rotationIndex = rotationIndex
      ..date = date.millisecondsSinceEpoch
      ..exercises.addAll(exercises);

    return workout.build();
  }

  /// Creates a new [Exercise] from the given [plannedExerciseId].
  ///
  /// Populates the exercise with weight and suggestion from the previous
  /// exercise of the same type and sets all reps to uncompleted.
  Future<Exercise> _instantiate(
      String plannedExerciseId, KnuffiMap<PlannedExercise> allExercises) async {
    final lastExercise = await _lastExercise(plannedExerciseId);

    final exercise = ExerciseBuilder()
      ..plannedExerciseId = plannedExerciseId
      ..weight = lastExercise?.weight ?? 0.0
      ..suggestion = _computeSuggestion(lastExercise, allExercises);
    for (final plannedSet in allExercises[plannedExerciseId].sets) {
      exercise.sets.add(WorkoutSet((b) => b
        ..completed = false
        ..plannedReps = plannedSet.reps
        ..actualReps = 0));
    }
    return exercise.build();
  }

  /// Notifies the workout DB that an exercise has been added for the given day.
  ///
  /// If the day is the current day, updates the current exercise.
  Future<void> planExerciseAdded(int day, String plannedExerciseId) async {
    final allExercises = await _exerciseDb.stream.first;
    _updateIfCurrent(day, (b) async {
      b.exercises.add(await _instantiate(plannedExerciseId, allExercises));
    });
  }

  /// Notifies the workout DB that an exercise has been removed for the given
  /// day.
  ///
  /// If the day is the current day, updates the current exercise.
  Future<void> planExerciseRemoved(int day, int exercise) async {
    _updateIfCurrent(day, (b) async {
      b.exercises.removeAt(exercise);
    });
  }

  /// Notifies the workout DB that an exercise has changed to a different one
  /// for the given day.
  ///
  /// If the day is the current day, updates the current exercise.
  Future<void> planExerciseChanged(
      int day, int exercise, String newPlannedExerciseId) async {
    final allExercises = await _exerciseDb.stream.first;
    _updateIfCurrent(day, (b) async {
      b.exercises[exercise] =
          await _instantiate(newPlannedExerciseId, allExercises);
    });
  }

  /// Updates the current Workout with the given [update], but only if [day]
  /// matches the day of the current workout.
  Future<void> _updateIfCurrent(
      int day, Future<void> Function(WorkoutBuilder) update) async {
    final map = await stream.first;
    if (map.isEmpty || map.values.first.rotationIndex != day) return;
    final key = map.keys.first;
    final builder = map[key].toBuilder();
    await update(builder);
    await save(key, builder.build());
  }

  /// Computes the suggested weight, given the last exercise of that type.
  ///
  /// [lastExercise] may be null if there is none.
  double _computeSuggestion(
      Exercise lastExercise, KnuffiMap<PlannedExercise> plannedExercises) {
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
