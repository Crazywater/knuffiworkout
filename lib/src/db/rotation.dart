import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:rxdart/rxdart.dart';

DatabaseReference get _db => userDb.child('rotation');

Observable<FireMap<Day>> get stream => _adapter.stream;
final _adapter = new FirebaseAdapter<Day>(_db, (e) => new Day.fromJson(e),
    comparator: (e1, e2) => e1.id.compareTo(e2.id));

Future initialize() async {
  await _adapter.open();
  if ((await stream.first).isEmpty) {
    await _populateInitial();
  }
}

Future<Null> newDay() async {
  final exercises = await exercise_db.stream.first;
  DatabaseReference ref = _db.push();
  final workout = new Day((b) => b
    ..id = ref.key
    ..plannedExerciseIds.add(exercises.keys.first));
  await ref.update(workout.toJson());
}

Future<Null> update(Day value) async {
  await _db.child(value.id).update(value.toJson());
}

Future<Null> moveUp(Day workout) async {
  final workouts = (await stream.first).values.toList();
  final index = workouts.indexWhere((w) => w.id == workout.id);
  await _swap(workouts, index, (index - 1) % workouts.length);
}

Future<Null> moveDown(Day workout) async {
  final workouts = (await stream.first).values.toList();
  final index = workouts.indexWhere((w) => w.id == workout.id);
  await _swap(workouts, index, (index + 1) % workouts.length);
}

Future<Null> remove(Day value) async {
  await _db.child(value.id).remove();
}

Future<Null> _swap(List<Day> workouts, int i, int j) async {
  final iId = workouts[i].id;
  final jId = workouts[j].id;

  final newI = workouts[i].rebuild((b) => b..id = jId);
  final newJ = workouts[j].rebuild((b) => b..id = iId);
  await update(newI);
  await update(newJ);
}

Future<Null> _populateInitial() async {
  final exercises = (await exercise_db.stream.first).values.toList();
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
    reference.update((workout.rebuild((b) => b..id = reference.key)).toJson());
  }
}

Day _plan(List<String> ids) => new Day((b) => b
  ..id = ''
  ..plannedExerciseIds.addAll(ids));
