import 'dart:async';

import 'package:knuffiworkout/src/db/exercise.dart';
import 'package:knuffiworkout/src/db/map_adapter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';

/// The rotation of exercise days.
class RotationDb {
  final Reference _db;
  final ExerciseDb _exerciseDb;
  final MapAdapter<Day> _adapter;

  RotationDb(this._db, this._exerciseDb)
      : _adapter = MapAdapter<Day>(_db, (e) => Day.fromJson(e),
            comparator: (e1, e2) => e1.id.compareTo(e2.id));

  /// [Day]s configured by the user.
  Stream<FireMap<Day>> get stream => _adapter.stream;

  /// Initializes the workout rotation database.
  ///
  /// Must be called once before accessing [stream].
  Future<void> initialize() async {
    await _adapter.open();
    if ((await stream.first).isEmpty) {
      await _populateInitial();
    }
  }

  /// Adds a new [Day] to the rotation.
  Future<void> newDay() async {
    final exercises = await _exerciseDb.stream.first;
    final ref = _db.push();
    final workout = Day((b) => b
      ..id = ref.key
      ..plannedExerciseIds.add(exercises.keys.first));
    await ref.set(workout.toJson());
  }

  /// Updates an existing [Day] with new data.
  Future<void> update(Day value) async {
    await _db.child(value.id).set(value.toJson());
  }

  /// Moves a [Day] one day earlier the rotation.
  Future<void> moveUp(Day workout) async {
    final workouts = (await stream.first).values.toList();
    final index = workouts.indexWhere((w) => w.id == workout.id);
    await _swap(workouts, index, (index - 1) % workouts.length);
  }

  /// Moves a [Day] one day later in the rotation.
  Future<void> moveDown(Day workout) async {
    final workouts = (await stream.first).values.toList();
    final index = workouts.indexWhere((w) => w.id == workout.id);
    await _swap(workouts, index, (index + 1) % workouts.length);
  }

  /// Deletes a [Day] from the rotation.
  Future<void> remove(Day value) async {
    await _db.child(value.id).remove();
  }

  /// Swaps two days.
  // TODO: Make this atomic.
  Future<void> _swap(List<Day> workouts, int i, int j) async {
    final iId = workouts[i].id;
    final jId = workouts[j].id;

    final newI = workouts[i].rebuild((b) => b..id = jId);
    final newJ = workouts[j].rebuild((b) => b..id = iId);
    await update(newI);
    await update(newJ);
  }

  /// Initializes the rotation database with sample data.
  Future<void> _populateInitial() async {
    final exercises = (await _exerciseDb.stream.first).values.toList();
    final _chinUps = exercises[0].id;
    final _ohp = exercises[1].id;
    final _rows = exercises[2].id;
    final _bench = exercises[3].id;
    final _squats = exercises[4].id;
    final _deadlifts = exercises[5].id;
    final _curls = exercises[6].id;
    final _running = exercises[7].id;
    final _hollowHolds = exercises[8].id;

    final rotation = [
      _plan([_chinUps, _ohp, _squats, _curls]),
      _plan([_rows, _bench, _deadlifts, _hollowHolds]),
      _plan([_chinUps, _ohp, _squats, _curls]),
      _plan([_running]),
      _plan([_rows, _bench, _squats, _hollowHolds]),
      _plan([_chinUps, _ohp, _deadlifts, _curls]),
      _plan([_rows, _bench, _squats, _hollowHolds]),
      _plan([_running]),
    ];

    for (final workout in rotation) {
      final reference = _db.push();
      reference.set((workout.rebuild((b) => b..id = reference.key)).toJson());
    }
  }

  Day _plan(List<String> ids) => Day((b) => b
    ..id = ''
    ..plannedExerciseIds.addAll(ids));
}
