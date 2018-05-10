import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:knuffiworkout/src/workout/workout_editor.dart';

/// View for the current workout.
class CurrentView extends StatefulWidget {
  CurrentView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CurrentViewState();
}

class _CurrentViewState extends State<CurrentView> with WidgetsBindingObserver {
  /// Temporary created, but not yet saved workout.
  ///
  /// This is created when you open the screen for the current workout, but
  /// haven't yet changed any values. Until you actually change something, we
  /// do not save this empty workout to Firebase.
  ///
  /// If you close and then re-open the app and haven't done anything with the
  /// temp workout, it gets recreated.
  Workout _tempWorkout;

  @override
  Widget build(BuildContext context) =>
      new StreamWidget1(workout_db.stream, _rebuild);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final now = new DateTime.now();
    if (_tempWorkout != null &&
        workout_db.toKey(now) != workout_db.toKey(_tempWorkout.dateTime)) {
      setState(() {
        _tempWorkout = null;
      });
    }
  }

  Widget _rebuild(FireMap<Workout> workouts, BuildContext context) {
    final now = new DateTime.now();
    final currentKey = workout_db.toKey(now);
    final existingWorkout = workouts[currentKey];

    if (existingWorkout == null && _tempWorkout == null) {
      workout_db.create(now).then((newWorkout) {
        setState(() {
          _tempWorkout = newWorkout;
        });
      });
      return new LinearProgressIndicator();
    }

    return new WorkoutEditor(existingWorkout ?? _tempWorkout,
        showsSuggestion: true);
  }
}
