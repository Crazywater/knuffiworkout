import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/formatter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/routes.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';

/// A view that lists all past workouts.
class PastView extends StatelessWidget {
  PastView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      StreamWidget2(workout_db.stream, exercise_db.stream, _rebuild);

  Widget _rebuild(FireMap<Workout> workouts, FireMap<PlannedExercise> exercises,
      BuildContext context) {
    final workoutKeys = workouts.keys.toList();
    final workoutList = workouts.values.toList();
    return ListView.builder(
      itemCount: workoutList.length,
      itemBuilder: (BuildContext context, int index) => _renderWorkout(
          workoutKeys[index], workoutList[index], exercises, context),
    );
  }

  Widget _renderWorkout(String workoutKey, Workout workout,
      FireMap<PlannedExercise> plannedExercises, BuildContext context) {
    var exercises = workout.exercises
        .map((e) => _renderExercise(e, plannedExercises[e.plannedExerciseId]))
        .toList();
    return KnuffiCard(
        header: _renderDate(workout.dateTime),
        children: exercises,
        onTap: () {
          editScreen.navigateTo(context, pathSegments: [workoutKey]);
        });
  }

  Widget _renderExercise(Exercise exercise, PlannedExercise plannedExercise) {
    var exerciseName = plannedExercise.name;
    if (plannedExercise.hasWeight && exercise.weight > 0) {
      exerciseName += '@${formatWeight(exercise.weight)}';
    }

    final sets = <Widget>[];
    for (final set in exercise.sets) {
      var style = TextStyle(color: colorForSet(set));
      sets.add(Text('${set.actualReps}', style: style));
      if (!identical(set, exercise.sets.last)) {
        sets.add(Text('/'));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(exerciseName),
        Row(children: sets),
      ],
    );
  }

  Widget _renderDate(DateTime date) {
    final renderedDate = formatDate(date);
    final weekday = _weekdays[date.weekday - 1];

    return Text('$weekday — $renderedDate', style: headerTextStyle);
  }
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];
