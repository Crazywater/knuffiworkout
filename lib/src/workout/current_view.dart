import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/map_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:knuffiworkout/src/workout/workout_editor.dart';

/// View for the current workout.
class CurrentView extends StatefulWidget {
  CurrentView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CurrentViewState();
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
      StreamWidget1(db.workouts.stream, _rebuild);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final now = DateTime.now();
    if (_tempWorkout != null && _toDay(now) != _toDay(_tempWorkout.dateTime)) {
      setState(() {
        _tempWorkout = null;
      });
    }
  }

  Widget _rebuild(FireMap<Workout> workouts, BuildContext context) {
    final now = DateTime.now();
    final today = _toDay(now);

    String existingKey;
    Workout existingWorkout;

    workouts.forEach((key, workout) {
      if (existingKey != null) return;
      if (_toDay(workout.dateTime) == today) {
        existingKey = key;
        existingWorkout = workout;
      }
    });

    if (existingWorkout == null && _tempWorkout == null) {
      db.workouts.create(now).then((newWorkout) {
        setState(() {
          _tempWorkout = newWorkout;
        });
      });
      return LinearProgressIndicator();
    }

    return WorkoutEditor(existingKey, existingWorkout ?? _tempWorkout,
        showsSuggestion: true);
  }

  DateTime _toDay(DateTime timestamp) =>
      DateTime(timestamp.year, timestamp.month, timestamp.day);
}
