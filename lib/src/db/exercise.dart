import 'dart:async';

import 'package:knuffiworkout/src/db/map_adapter.dart';
import 'package:knuffiworkout/src/initial_data.dart' as initial_data;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';
import 'package:rxdart/rxdart.dart';

class ExerciseDb {
  final Reference _db;
  final MapAdapter<PlannedExercise> _adapter;

  ExerciseDb(this._db)
      : _adapter = MapAdapter<PlannedExercise>(
            _db, (e) => PlannedExercise.fromJson(e),
            comparator: (e1, e2) => e1.id.compareTo(e2.id));

  /// [PlannedExercise]s saved by the user.
  Observable<FireMap<PlannedExercise>> get stream => _adapter.stream;

  /// Initializes the database of planned exercises from Firebase.
  ///
  /// Must be called once before accessing [stream].
  Future<void> initialize() async {
    await _adapter.open();
    if ((await stream.first).isEmpty) {
      await _populateInitial();
    }
  }

  /// Creates a new exercise.
  Future<void> createNew() async {
    final ref = _db.push();
    final exercise = PlannedExercise((b) => b
      ..id = ref.key
      ..name = 'Ear shrugs'
      ..sets.add(PlannedSet((b) => b..reps = 5))
      ..hasWeight = false
      ..increase = 0.0
      ..decreaseFactor = 0.0);
    await ref.update(exercise.toJson());
  }

  /// Updates data for an existing exercise.
  Future<void> update(PlannedExercise value) async {
    await _db.child(value.id).update(value.toJson());
  }

  /// Initializes the planned exercise database with sample data.
  Future<void> _populateInitial() async {
    for (final exercise in initial_data.exercises) {
      final ref = _db.push();
      await ref.update((exercise.rebuild((b) => b..id = ref.key)).toJson());
    }
  }
}
