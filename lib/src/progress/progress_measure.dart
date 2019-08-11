import 'dart:math' show min;
import 'package:knuffiworkout/src/model.dart';

/// A way to measure progress, shown in the chart.
class ProgressMeasure {
  /// Display name shown in the dropdown.
  final String name;

  /// How to extract this measure from an [Exercise].
  final double Function(Exercise) function;

  /// Whether this measure only makes sense if the exercise is weighted.
  final bool needsWeight;

  ProgressMeasure(this.name, this.function, {this.needsWeight = false});

  /// All available [ProgressMeasure]s.
  static final all = [weight, reps, oneRepMax];

  /// Progress measures that don't need a weight.
  static List<ProgressMeasure> get unweighted =>
      all.where((measure) => !measure.needsWeight).toList();

  /// Weight for the exercise.
  static final weight = ProgressMeasure('Weight', (exercise) => exercise.weight,
      needsWeight: true);

  /// Total reps, across sets.
  static final reps = ProgressMeasure(
      'Total reps',
      (exercise) => exercise.sets
          .fold(0, (reps, set) => reps + set.actualReps)
          .toDouble());

  /// Estimated one-rep max, based on reps and weight of the last set.
  static final oneRepMax = ProgressMeasure('Estimated 1-rep max', (exercise) {
    final reps = exercise.sets.last.actualReps;
    if (reps == 0) return null;
    final weight = exercise.weight;
    return _predictOneRepMax(reps, weight);
  }, needsWeight: true);
}

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
