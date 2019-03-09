import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/progress/progress_chart.dart';
import 'package:knuffiworkout/src/progress/progress_view_model.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:rxdart/rxdart.dart';

/// Shows the progress over time.
class ProgressView extends StatefulWidget {
  ProgressView({Key key}) : super(key: key);

  @override
  _ProgressViewState createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  final _viewModel =
      BehaviorSubject<ProgressViewModel>(seedValue: ProgressViewModel.defaults);

  @override
  Widget build(BuildContext context) => StreamWidget3(
      db.workouts.stream, db.exercises.stream, _viewModel.stream, _rebuild);

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
      return LinearProgressIndicator();
    }

    final selectedExercise = exercises[viewModel.exerciseId];
    if (viewModel.measure.needsWeight && !selectedExercise.hasWeight) {
      _updateState((b) => b.measure = ProgressMeasure.unweighted.first);
      return LinearProgressIndicator();
    }

    final workoutList = workouts.values.toList();

    final dataPoints = <ChartPoint>[];
    for (final workout in workoutList.reversed) {
      final matchingExercises = workout.exercises
          .where((e) => e.plannedExerciseId == viewModel.exerciseId);
      final measures = matchingExercises.map(viewModel.measure.function);
      dataPoints.addAll(measures
          .where((measure) => measure != null)
          .map((measure) => ChartPoint(workout.dateTime, measure)));
    }

    final availableMeasures = selectedExercise.hasWeight
        ? ProgressMeasure.all
        : ProgressMeasure.unweighted;

    final measureSelector = availableMeasures.length == 1
        ? Text(viewModel.measure.name)
        : DropdownButton<ProgressMeasure>(
            items: availableMeasures
                .map((measure) =>
                    DropdownMenuItem(value: measure, child: Text(measure.name)))
                .toList(),
            onChanged: (measure) {
              _updateState((b) => b.measure = measure);
            },
            value: viewModel.measure);

    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                    items: exerciseIds
                        .map((id) => DropdownMenuItem(
                              value: id,
                              child: Text(exercises[id].name),
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
          Expanded(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: dataPoints.isEmpty
                      ? Text('No data yet')
                      : ProgressChart(dataPoints))),
        ]);
  }

  void _updateState(updates(ProgressViewModelBuilder b)) {
    _viewModel.add(_viewModel.value.rebuild(updates));
  }
}
