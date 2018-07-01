import 'dart:math' show min;

import 'package:built_value/built_value.dart';
import 'package:knuffiworkout/src/model.dart';

part 'progress_view_model.g.dart';

/// Local state of the progress view.
abstract class ProgressViewModel
    implements Built<ProgressViewModel, ProgressViewModelBuilder> {
  /// Default [ProgressViewModel] when opening the view.
  static final ProgressViewModel defaults = (new ProgressViewModelBuilder()
        ..measure = ProgressMeasure.oneRepMax)
      .build();

  /// Currently selected [ProgressMeasure].
  ProgressMeasure get measure;

  /// Currently selected exercise id.
  ///
  /// `null` if the user hasn't selected any yet.
  @nullable
  String get exerciseId;

  ProgressViewModel._();

  factory ProgressViewModel([updates(ProgressViewModelBuilder b)]) =
      _$ProgressViewModel;
}

/// A way to measure progress, shown in the chart.
class ProgressMeasure {
  /// Display name shown in the dropdown.
  final String name;

  /// How to extract this measure from an [Exercise].
  final _MeasureFunction function;

  /// Whether this measure only makes sense if the exercise is weighted.
  final bool needsWeight;

  ProgressMeasure(this.name, this.function, {this.needsWeight = false});

  /// All available [ProgressMeasure]s.
  static final all = [weight, reps, oneRepMax];

  /// Progress measures that don't need a weight.
  static List<ProgressMeasure> get unweighted =>
      all.where((measure) => !measure.needsWeight).toList();

  /// Weight for the exercise.
  static final weight = new ProgressMeasure(
      'Weight', (exercise) => exercise.weight,
      needsWeight: true);

  /// Total reps, across sets.
  static final reps = new ProgressMeasure('Total reps', (exercise) {
    int reps = 0;
    for (final set in exercise.sets) {
      reps += set.actualReps;
    }
    return reps.toDouble();
  });

  /// Estimated one-rep max, based on reps and weight of the last set.
  static final oneRepMax =
      new ProgressMeasure('Estimated 1-rep max', (exercise) {
    final reps = exercise.sets.last.actualReps;
    if (reps == 0) return null;
    final weight = exercise.weight;
    return _predictOneRepMax(reps, weight);
  }, needsWeight: true);
}

typedef _MeasureFunction = double Function(Exercise);

/// Factors to translate n reps of some weight into the one rep max.
final _repsToOneRepMax = [
  1,
  .95,
  .93,
  .90,
  .87,
  .85,
  .83,
  .80,
  .77,
  .75,
  .72,
  .67
];

double _predictOneRepMax(int reps, double weight) {
  final index = min(reps - 1, _repsToOneRepMax.length - 1);
  return weight / _repsToOneRepMax[index];
}
