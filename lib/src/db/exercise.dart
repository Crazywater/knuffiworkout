import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/initial_data.dart' as initial_data;
import 'package:knuffiworkout/src/model.dart';
import 'package:rxdart/rxdart.dart';

DatabaseReference get _db => userDb.child('exercise');

/// [PlannedExercise]s saved by the user.
Observable<FireMap<PlannedExercise>> get stream => _adapter.stream;
final _adapter = new FirebaseAdapter<PlannedExercise>(
    _db, (e) => new PlannedExercise.fromJson(e),
    comparator: (e1, e2) => e1.id.compareTo(e2.id));

/// Initializes the database of planned exercises from Firebase.
///
/// Must be called once before accessing [stream].
Future initialize() async {
  await _adapter.open();
  if ((await stream.first).isEmpty) {
    await _populateInitial();
  }
}

/// Creates a new exercise.
Future<Null> createNew() async {
  DatabaseReference ref = _db.push();
  final exercise = new PlannedExercise((b) => b
    ..id = ref.key
    ..name = 'Ear shrugs'
    ..sets.add(new PlannedSet((b) => b..reps = 5))
    ..hasWeight = false
    ..increase = 0.0
    ..decreaseFactor = 0.0);
  await ref.update(exercise.toJson());
}

/// Updates data for an existing exercise.
Future<Null> update(PlannedExercise value) async {
  await _db.child(value.id).update(value.toJson());
}

/// Initializes the planned exercise database with sample data.
Future _populateInitial() async {
  for (final exercise in initial_data.exercises) {
    DatabaseReference ref = _db.push();
    await ref.update((exercise.rebuild((b) => b..id = ref.key)).toJson());
  }
}
