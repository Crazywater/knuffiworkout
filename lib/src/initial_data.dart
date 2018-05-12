import 'package:knuffiworkout/src/model.dart';

final _threex5 = [5, 5, 5].map(_toSet).toList();

final _threex16 = [16, 16, 16].map(_toSet).toList();

final _threex30 = [30, 30, 30].map(_toSet).toList();

final _chinUps = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Chinups'
  ..sets.addAll(_threex5)
  ..hasWeight = false
  ..increase = 0.0
  ..decreaseFactor = 0.0);
final _rows = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Barbell Rows'
  ..sets.addAll(_threex5)
  ..hasWeight = true
  ..increase = 1.25
  ..decreaseFactor = 0.9);
final _ohp = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Overhead Press'
  ..sets.addAll(_threex5)
  ..hasWeight = true
  ..increase = 1.25
  ..decreaseFactor = 0.9);
final _bench = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Bench Press'
  ..sets.addAll(_threex5)
  ..hasWeight = true
  ..increase = 1.25
  ..decreaseFactor = 0.9);
final _squats = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Squats'
  ..sets.addAll(_threex5)
  ..hasWeight = true
  ..increase = 2.5
  ..decreaseFactor = 0.9);
final _deadlifts = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Deadlifts'
  ..sets.addAll(_threex5)
  ..hasWeight = true
  ..increase = 2.5
  ..decreaseFactor = 0.9);
final _curls = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Curls'
  ..sets.addAll(_threex16)
  ..hasWeight = true
  ..increase = 0.5
  ..decreaseFactor = 0.0);
final _running = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Running (minutes)'
  ..sets.addAll([_toSet(30)])
  ..hasWeight = false
  ..increase = 0.0
  ..decreaseFactor = 0.0);
final _hollowHolds = new PlannedExercise((b) => b
  ..id = ''
  ..name = 'Hollow holds (seconds)'
  ..sets.addAll(_threex30)
  ..hasWeight = false
  ..increase = 0.0
  ..decreaseFactor = 0.0);

/// Initial suggested exercises.
final exercises = [
  _chinUps,
  _rows,
  _ohp,
  _bench,
  _squats,
  _deadlifts,
  _curls,
  _running,
  _hollowHolds,
];

PlannedSet _toSet(int i) => new PlannedSet((b) => b..reps = i);
