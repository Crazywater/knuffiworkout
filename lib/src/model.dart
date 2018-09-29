import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'model.g.dart';

/// [Serializers] to serialize the model classes to JSON.
@SerializersFor(
    [Day, PlannedExercise, PlannedSet, WorkoutSet, Exercise, Workout])
final Serializers serializersInternal = _$serializersInternal;
final serializers =
    (serializersInternal.toBuilder()..addPlugin(StandardJsonPlugin())).build();

/// A day in the rotation of exercises.
///
/// Contains the [PlannedExercise]s for that day.
abstract class Day implements Built<Day, DayBuilder> {
  static Serializer<Day> get serializer => _$daySerializer;

  /// Unique ID for this day in the rotation.
  String get id;

  /// IDs of the [PlannedExercise]s for this day.
  BuiltList<String> get plannedExerciseIds;

  Day._();

  factory Day([updates(DayBuilder b)]) = _$Day;

  factory Day.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map toJson() => serializers.serializeWith(serializer, this);
}

/// A type of exercise to perform (e.g. deadlifts, squats, ...).
///
/// Contains the planned sets and progression.
abstract class PlannedExercise
    implements Built<PlannedExercise, PlannedExerciseBuilder> {
  static Serializer<PlannedExercise> get serializer =>
      _$plannedExerciseSerializer;

  /// Unique ID for this exercise.
  String get id;

  /// Display name in the UI.
  String get name;

  /// Sets that are planned to be performed.
  BuiltList<PlannedSet> get sets;

  /// Whether this exercise is weighted.
  bool get hasWeight;

  /// How much to increase the weight (absolute) if as many reps as planned
  /// were performed.
  double get increase;

  /// How much to decrease the weight (relative to the current weight) if the
  /// user performed fewer reps than planned.
  double get decreaseFactor;

  PlannedExercise._();

  factory PlannedExercise([updates(PlannedExerciseBuilder b)]) =
      _$PlannedExercise;

  factory PlannedExercise.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

/// A set in a [PlannedExercise], consisting of a number of reps.
abstract class PlannedSet implements Built<PlannedSet, PlannedSetBuilder> {
  static Serializer<PlannedSet> get serializer => _$plannedSetSerializer;

  /// How many reps are planned for this set.
  int get reps;

  PlannedSet._();

  factory PlannedSet([updates(PlannedSetBuilder b)]) = _$PlannedSet;

  factory PlannedSet.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

/// An actual performed set.
abstract class WorkoutSet implements Built<WorkoutSet, WorkoutSetBuilder> {
  static Serializer<WorkoutSet> get serializer => _$workoutSetSerializer;

  /// Number of reps that were planned in the corresponding [PlannedSet].
  int get plannedReps;

  /// Reps actually performed.
  int get actualReps;

  /// Whether the user has attempted the set at all.
  bool get completed;

  WorkoutSet._();

  factory WorkoutSet([updates(WorkoutSetBuilder b)]) = _$WorkoutSet;

  factory WorkoutSet.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

/// An actually performed exercise, consisting of a number of [WorkoutSet]s.
abstract class Exercise implements Built<Exercise, ExerciseBuilder> {
  static Serializer<Exercise> get serializer => _$exerciseSerializer;

  /// ID of the corresponding [PlannedExercise].
  String get plannedExerciseId;

  /// Performed sets in this exercise.
  BuiltList<WorkoutSet> get sets;

  /// The weight for this set.
  double get weight;

  /// Suggested weight for this exercise.
  ///
  /// Can be `null` if the exercise is unweighted.
  @nullable
  double get suggestion;

  Exercise._();

  factory Exercise([updates(ExerciseBuilder b)]) = _$Exercise;

  factory Exercise.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

/// An actually performed workout, consisting of a number of [Exericse]s on a
/// given day.
abstract class Workout implements Built<Workout, WorkoutBuilder> {
  static Serializer<Workout> get serializer => _$workoutSerializer;

  /// When this workout was performed.
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date);

  /// Timestamp of this workout in millis since epoch.
  int get date;

  /// [Exercise]s performed on that day.
  BuiltList<Exercise> get exercises;

  /// Index in the rotation of [Day]s of this workout.
  int get rotationIndex;

  Workout._();

  factory Workout([updates(WorkoutBuilder b)]) = _$Workout;

  factory Workout.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
