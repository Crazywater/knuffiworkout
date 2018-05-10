import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:knuffiworkout/src/workout/workout_editor.dart';

/// Screen for editing a workout.
class EditScreen extends StatelessWidget {
  final DateTime _date;

  EditScreen(this._date, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      new StreamWidget1(workout_db.stream, _rebuild);

  Widget _rebuild(FireMap<Workout> workouts, BuildContext context) {
    final workout = workouts[workout_db.toKey(_date)];
    return new Scaffold(
      appBar: new AppBar(title: new Text('Edit workout')),
      body: new WorkoutEditor(workout),
    );
  }
}
