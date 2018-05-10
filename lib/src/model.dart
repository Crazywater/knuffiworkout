import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

part 'model.g.dart';

@SerializersFor(
    const [Day, PlannedExercise, PlannedSet, WorkoutSet, Exercise, Workout])
final Serializers serializersInternal = _$serializersInternal;
final serializers = (serializersInternal.toBuilder()
      ..addPlugin(new StandardJsonPlugin()))
    .build();

abstract class Day implements Built<Day, DayBuilder> {
  static Serializer<Day> get serializer => _$daySerializer;

  String get id;

  BuiltList<String> get plannedExerciseIds;

  Day._();

  factory Day([updates(DayBuilder b)]) = _$Day;

  factory Day.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map toJson() => serializers.serializeWith(serializer, this);
}

abstract class PlannedExercise
    implements Built<PlannedExercise, PlannedExerciseBuilder> {
  static Serializer<PlannedExercise> get serializer =>
      _$plannedExerciseSerializer;

  String get id;

  String get name;

  BuiltList<PlannedSet> get sets;

  bool get hasWeight;

  double get increase;

  double get decreaseFactor;

  PlannedExercise._();

  factory PlannedExercise([updates(PlannedExerciseBuilder b)]) =
      _$PlannedExercise;

  factory PlannedExercise.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class PlannedSet implements Built<PlannedSet, PlannedSetBuilder> {
  static Serializer<PlannedSet> get serializer => _$plannedSetSerializer;

  int get reps;

  PlannedSet._();

  factory PlannedSet([updates(PlannedSetBuilder b)]) = _$PlannedSet;

  factory PlannedSet.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class WorkoutSet implements Built<WorkoutSet, WorkoutSetBuilder> {
  static Serializer<WorkoutSet> get serializer => _$workoutSetSerializer;

  int get plannedReps;

  int get actualReps;

  bool get completed;

  WorkoutSet._();

  factory WorkoutSet([updates(WorkoutSetBuilder b)]) = _$WorkoutSet;

  factory WorkoutSet.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class Exercise implements Built<Exercise, ExerciseBuilder> {
  static Serializer<Exercise> get serializer => _$exerciseSerializer;

  String get plannedExerciseId;

  BuiltList<WorkoutSet> get sets;

  double get weight;

  @nullable
  double get suggestion;

  Exercise._();

  factory Exercise([updates(ExerciseBuilder b)]) = _$Exercise;

  factory Exercise.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}

abstract class Workout implements Built<Workout, WorkoutBuilder> {
  static Serializer<Workout> get serializer => _$workoutSerializer;

  DateTime get dateTime => new DateTime.fromMillisecondsSinceEpoch(date);

  int get date;

  BuiltList<Exercise> get exercises;

  int get rotationIndex;

  Workout._();

  factory Workout([updates(WorkoutBuilder b)]) = _$Workout;

  factory Workout.fromJson(Map json) =>
      serializers.deserializeWith(serializer, json);

  Map<String, dynamic> toJson() => serializers.serializeWith(serializer, this);
}
