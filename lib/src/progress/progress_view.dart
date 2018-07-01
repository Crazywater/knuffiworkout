import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/progress/progress_chart.dart';
import 'package:knuffiworkout/src/progress/progress_view_model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:rxdart/rxdart.dart';

/// Shows the progress over time.
class ProgressView extends StatefulWidget {
  ProgressView({Key key}) : super(key: key);

  @override
  _ProgressViewState createState() => new _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  final _viewModel = new BehaviorSubject<ProgressViewModel>(
      seedValue: ProgressViewModel.defaults);

  @override
  Widget build(BuildContext context) => new StreamWidget3(
      workout_db.stream, exercise_db.stream, _viewModel.stream, _rebuild);

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  Widget _rebuild(FireMap<Workout> workouts, FireMap<PlannedExercise> exercises,
      ProgressViewModel viewModel, BuildContext context) {
    final exerciseIds = exercises.keys.toList();
    exerciseIds.sort(
        (left, right) => exercises[left].name.compareTo(exercises[right].name));
    if (!exerciseIds.contains(viewModel.exerciseId)) {
      _updateState((b) => b.exerciseId = exerciseIds.first);
      return new LinearProgressIndicator();
    }

    final selectedExercise = exercises[viewModel.exerciseId];
    if (viewModel.measure.needsWeight && !selectedExercise.hasWeight) {
      _updateState((b) => b.measure = ProgressMeasure.unweighted.first);
      return new LinearProgressIndicator();
    }

    final workoutList = workouts.values.toList();

    final dataPoints = <ChartPoint>[];
    for (final workout in workoutList.reversed) {
      final matchingExercises = workout.exercises
          .where((e) => e.plannedExerciseId == viewModel.exerciseId);
      final measures = matchingExercises.map(viewModel.measure.function);
      dataPoints.addAll(measures
          .where((measure) => measure != null)
          .map((measure) => new ChartPoint(workout.dateTime, measure)));
    }

    final availableMeasures = selectedExercise.hasWeight
        ? ProgressMeasure.all
        : ProgressMeasure.unweighted;

    final measureSelector = availableMeasures.length == 1
        ? new Text(viewModel.measure.name)
        : new DropdownButton<ProgressMeasure>(
            items: availableMeasures
                .map((measure) => new DropdownMenuItem(
                    value: measure, child: new Text(measure.name)))
                .toList(),
            onChanged: (measure) {
              _updateState((b) => b.measure = measure);
            },
            value: viewModel.measure);

    return new Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new DropdownButton<String>(
                    items: exerciseIds
                        .map((id) => new DropdownMenuItem(
                              value: id,
                              child: new Text(exercises[id].name),
                            ))
                        .toList(),
                    onChanged: (exerciseId) {
                      _updateState((b) => b.exerciseId = exerciseId);
                    },
                    value: viewModel.exerciseId),
                measureSelector,
              ],
            ),
          ),
          new Expanded(
              child: new Padding(
                  padding: new EdgeInsets.all(16.0),
                  child: dataPoints.isEmpty
                      ? new Text('No data yet')
                      : new ProgressChart(dataPoints))),
        ]);
  }

  void _updateState(updates(ProgressViewModelBuilder b)) {
    _viewModel.add(_viewModel.value.rebuild(updates));
  }
}
