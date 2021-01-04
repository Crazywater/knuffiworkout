// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializersInternal = (new Serializers().toBuilder()
      ..add(Day.serializer)
      ..add(Exercise.serializer)
      ..add(PlannedExercise.serializer)
      ..add(PlannedSet.serializer)
      ..add(Workout.serializer)
      ..add(WorkoutSet.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Exercise)]),
          () => new ListBuilder<Exercise>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PlannedSet)]),
          () => new ListBuilder<PlannedSet>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => new ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WorkoutSet)]),
          () => new ListBuilder<WorkoutSet>()))
    .build();
Serializer<Day> _$daySerializer = new _$DaySerializer();
Serializer<PlannedExercise> _$plannedExerciseSerializer =
    new _$PlannedExerciseSerializer();
Serializer<PlannedSet> _$plannedSetSerializer = new _$PlannedSetSerializer();
Serializer<WorkoutSet> _$workoutSetSerializer = new _$WorkoutSetSerializer();
Serializer<Exercise> _$exerciseSerializer = new _$ExerciseSerializer();
Serializer<Workout> _$workoutSerializer = new _$WorkoutSerializer();

class _$DaySerializer implements StructuredSerializer<Day> {
  @override
  final Iterable<Type> types = const [Day, _$Day];
  @override
  final String wireName = 'Day';

  @override
  Iterable<Object> serialize(Serializers serializers, Day object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'plannedExerciseIds',
      serializers.serialize(object.plannedExerciseIds,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

    return result;
  }

  @override
  Day deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DayBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'plannedExerciseIds':
          result.plannedExerciseIds.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$PlannedExerciseSerializer
    implements StructuredSerializer<PlannedExercise> {
  @override
  final Iterable<Type> types = const [PlannedExercise, _$PlannedExercise];
  @override
  final String wireName = 'PlannedExercise';

  @override
  Iterable<Object> serialize(Serializers serializers, PlannedExercise object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'sets',
      serializers.serialize(object.sets,
          specifiedType:
              const FullType(BuiltList, const [const FullType(PlannedSet)])),
      'hasWeight',
      serializers.serialize(object.hasWeight,
          specifiedType: const FullType(bool)),
      'increase',
      serializers.serialize(object.increase,
          specifiedType: const FullType(double)),
      'decreaseFactor',
      serializers.serialize(object.decreaseFactor,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  PlannedExercise deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlannedExerciseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sets':
          result.sets.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(PlannedSet)]))
              as BuiltList<Object>);
          break;
        case 'hasWeight':
          result.hasWeight = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'increase':
          result.increase = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'decreaseFactor':
          result.decreaseFactor = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$PlannedSetSerializer implements StructuredSerializer<PlannedSet> {
  @override
  final Iterable<Type> types = const [PlannedSet, _$PlannedSet];
  @override
  final String wireName = 'PlannedSet';

  @override
  Iterable<Object> serialize(Serializers serializers, PlannedSet object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'reps',
      serializers.serialize(object.reps, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  PlannedSet deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PlannedSetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'reps':
          result.reps = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutSetSerializer implements StructuredSerializer<WorkoutSet> {
  @override
  final Iterable<Type> types = const [WorkoutSet, _$WorkoutSet];
  @override
  final String wireName = 'WorkoutSet';

  @override
  Iterable<Object> serialize(Serializers serializers, WorkoutSet object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'plannedReps',
      serializers.serialize(object.plannedReps,
          specifiedType: const FullType(int)),
      'actualReps',
      serializers.serialize(object.actualReps,
          specifiedType: const FullType(int)),
      'completed',
      serializers.serialize(object.completed,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  WorkoutSet deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutSetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'plannedReps':
          result.plannedReps = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'actualReps':
          result.actualReps = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$ExerciseSerializer implements StructuredSerializer<Exercise> {
  @override
  final Iterable<Type> types = const [Exercise, _$Exercise];
  @override
  final String wireName = 'Exercise';

  @override
  Iterable<Object> serialize(Serializers serializers, Exercise object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'plannedExerciseId',
      serializers.serialize(object.plannedExerciseId,
          specifiedType: const FullType(String)),
      'sets',
      serializers.serialize(object.sets,
          specifiedType:
              const FullType(BuiltList, const [const FullType(WorkoutSet)])),
      'weight',
      serializers.serialize(object.weight,
          specifiedType: const FullType(double)),
    ];
    if (object.suggestion != null) {
      result
        ..add('suggestion')
        ..add(serializers.serialize(object.suggestion,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  Exercise deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ExerciseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'plannedExerciseId':
          result.plannedExerciseId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'sets':
          result.sets.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(WorkoutSet)]))
              as BuiltList<Object>);
          break;
        case 'weight':
          result.weight = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'suggestion':
          result.suggestion = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$WorkoutSerializer implements StructuredSerializer<Workout> {
  @override
  final Iterable<Type> types = const [Workout, _$Workout];
  @override
  final String wireName = 'Workout';

  @override
  Iterable<Object> serialize(Serializers serializers, Workout object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'date',
      serializers.serialize(object.date, specifiedType: const FullType(int)),
      'exercises',
      serializers.serialize(object.exercises,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Exercise)])),
      'rotationIndex',
      serializers.serialize(object.rotationIndex,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Workout deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new WorkoutBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'date':
          result.date = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'exercises':
          result.exercises.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Exercise)]))
              as BuiltList<Object>);
          break;
        case 'rotationIndex':
          result.rotationIndex = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Day extends Day {
  @override
  final String id;
  @override
  final BuiltList<String> plannedExerciseIds;

  factory _$Day([void Function(DayBuilder) updates]) =>
      (new DayBuilder()..update(updates)).build();

  _$Day._({this.id, this.plannedExerciseIds}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Day', 'id');
    }
    if (plannedExerciseIds == null) {
      throw new BuiltValueNullFieldError('Day', 'plannedExerciseIds');
    }
  }

  @override
  Day rebuild(void Function(DayBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayBuilder toBuilder() => new DayBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Day &&
        id == other.id &&
        plannedExerciseIds == other.plannedExerciseIds;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), plannedExerciseIds.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Day')
          ..add('id', id)
          ..add('plannedExerciseIds', plannedExerciseIds))
        .toString();
  }
}

class DayBuilder implements Builder<Day, DayBuilder> {
  _$Day _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  ListBuilder<String> _plannedExerciseIds;
  ListBuilder<String> get plannedExerciseIds =>
      _$this._plannedExerciseIds ??= new ListBuilder<String>();
  set plannedExerciseIds(ListBuilder<String> plannedExerciseIds) =>
      _$this._plannedExerciseIds = plannedExerciseIds;

  DayBuilder();

  DayBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _plannedExerciseIds = _$v.plannedExerciseIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Day other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Day;
  }

  @override
  void update(void Function(DayBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Day build() {
    _$Day _$result;
    try {
      _$result = _$v ??
          new _$Day._(id: id, plannedExerciseIds: plannedExerciseIds.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'plannedExerciseIds';
        plannedExerciseIds.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Day', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PlannedExercise extends PlannedExercise {
  @override
  final String id;
  @override
  final String name;
  @override
  final BuiltList<PlannedSet> sets;
  @override
  final bool hasWeight;
  @override
  final double increase;
  @override
  final double decreaseFactor;

  factory _$PlannedExercise([void Function(PlannedExerciseBuilder) updates]) =>
      (new PlannedExerciseBuilder()..update(updates)).build();

  _$PlannedExercise._(
      {this.id,
      this.name,
      this.sets,
      this.hasWeight,
      this.increase,
      this.decreaseFactor})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'name');
    }
    if (sets == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'sets');
    }
    if (hasWeight == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'hasWeight');
    }
    if (increase == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'increase');
    }
    if (decreaseFactor == null) {
      throw new BuiltValueNullFieldError('PlannedExercise', 'decreaseFactor');
    }
  }

  @override
  PlannedExercise rebuild(void Function(PlannedExerciseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlannedExerciseBuilder toBuilder() =>
      new PlannedExerciseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlannedExercise &&
        id == other.id &&
        name == other.name &&
        sets == other.sets &&
        hasWeight == other.hasWeight &&
        increase == other.increase &&
        decreaseFactor == other.decreaseFactor;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, id.hashCode), name.hashCode), sets.hashCode),
                hasWeight.hashCode),
            increase.hashCode),
        decreaseFactor.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PlannedExercise')
          ..add('id', id)
          ..add('name', name)
          ..add('sets', sets)
          ..add('hasWeight', hasWeight)
          ..add('increase', increase)
          ..add('decreaseFactor', decreaseFactor))
        .toString();
  }
}

class PlannedExerciseBuilder
    implements Builder<PlannedExercise, PlannedExerciseBuilder> {
  _$PlannedExercise _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  ListBuilder<PlannedSet> _sets;
  ListBuilder<PlannedSet> get sets =>
      _$this._sets ??= new ListBuilder<PlannedSet>();
  set sets(ListBuilder<PlannedSet> sets) => _$this._sets = sets;

  bool _hasWeight;
  bool get hasWeight => _$this._hasWeight;
  set hasWeight(bool hasWeight) => _$this._hasWeight = hasWeight;

  double _increase;
  double get increase => _$this._increase;
  set increase(double increase) => _$this._increase = increase;

  double _decreaseFactor;
  double get decreaseFactor => _$this._decreaseFactor;
  set decreaseFactor(double decreaseFactor) =>
      _$this._decreaseFactor = decreaseFactor;

  PlannedExerciseBuilder();

  PlannedExerciseBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _sets = _$v.sets?.toBuilder();
      _hasWeight = _$v.hasWeight;
      _increase = _$v.increase;
      _decreaseFactor = _$v.decreaseFactor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlannedExercise other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PlannedExercise;
  }

  @override
  void update(void Function(PlannedExerciseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PlannedExercise build() {
    _$PlannedExercise _$result;
    try {
      _$result = _$v ??
          new _$PlannedExercise._(
              id: id,
              name: name,
              sets: sets.build(),
              hasWeight: hasWeight,
              increase: increase,
              decreaseFactor: decreaseFactor);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'sets';
        sets.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PlannedExercise', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PlannedSet extends PlannedSet {
  @override
  final int reps;

  factory _$PlannedSet([void Function(PlannedSetBuilder) updates]) =>
      (new PlannedSetBuilder()..update(updates)).build();

  _$PlannedSet._({this.reps}) : super._() {
    if (reps == null) {
      throw new BuiltValueNullFieldError('PlannedSet', 'reps');
    }
  }

  @override
  PlannedSet rebuild(void Function(PlannedSetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlannedSetBuilder toBuilder() => new PlannedSetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlannedSet && reps == other.reps;
  }

  @override
  int get hashCode {
    return $jf($jc(0, reps.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PlannedSet')..add('reps', reps))
        .toString();
  }
}

class PlannedSetBuilder implements Builder<PlannedSet, PlannedSetBuilder> {
  _$PlannedSet _$v;

  int _reps;
  int get reps => _$this._reps;
  set reps(int reps) => _$this._reps = reps;

  PlannedSetBuilder();

  PlannedSetBuilder get _$this {
    if (_$v != null) {
      _reps = _$v.reps;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlannedSet other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PlannedSet;
  }

  @override
  void update(void Function(PlannedSetBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PlannedSet build() {
    final _$result = _$v ?? new _$PlannedSet._(reps: reps);
    replace(_$result);
    return _$result;
  }
}

class _$WorkoutSet extends WorkoutSet {
  @override
  final int plannedReps;
  @override
  final int actualReps;
  @override
  final bool completed;

  factory _$WorkoutSet([void Function(WorkoutSetBuilder) updates]) =>
      (new WorkoutSetBuilder()..update(updates)).build();

  _$WorkoutSet._({this.plannedReps, this.actualReps, this.completed})
      : super._() {
    if (plannedReps == null) {
      throw new BuiltValueNullFieldError('WorkoutSet', 'plannedReps');
    }
    if (actualReps == null) {
      throw new BuiltValueNullFieldError('WorkoutSet', 'actualReps');
    }
    if (completed == null) {
      throw new BuiltValueNullFieldError('WorkoutSet', 'completed');
    }
  }

  @override
  WorkoutSet rebuild(void Function(WorkoutSetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutSetBuilder toBuilder() => new WorkoutSetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkoutSet &&
        plannedReps == other.plannedReps &&
        actualReps == other.actualReps &&
        completed == other.completed;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, plannedReps.hashCode), actualReps.hashCode),
        completed.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('WorkoutSet')
          ..add('plannedReps', plannedReps)
          ..add('actualReps', actualReps)
          ..add('completed', completed))
        .toString();
  }
}

class WorkoutSetBuilder implements Builder<WorkoutSet, WorkoutSetBuilder> {
  _$WorkoutSet _$v;

  int _plannedReps;
  int get plannedReps => _$this._plannedReps;
  set plannedReps(int plannedReps) => _$this._plannedReps = plannedReps;

  int _actualReps;
  int get actualReps => _$this._actualReps;
  set actualReps(int actualReps) => _$this._actualReps = actualReps;

  bool _completed;
  bool get completed => _$this._completed;
  set completed(bool completed) => _$this._completed = completed;

  WorkoutSetBuilder();

  WorkoutSetBuilder get _$this {
    if (_$v != null) {
      _plannedReps = _$v.plannedReps;
      _actualReps = _$v.actualReps;
      _completed = _$v.completed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkoutSet other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$WorkoutSet;
  }

  @override
  void update(void Function(WorkoutSetBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$WorkoutSet build() {
    final _$result = _$v ??
        new _$WorkoutSet._(
            plannedReps: plannedReps,
            actualReps: actualReps,
            completed: completed);
    replace(_$result);
    return _$result;
  }
}

class _$Exercise extends Exercise {
  @override
  final String plannedExerciseId;
  @override
  final BuiltList<WorkoutSet> sets;
  @override
  final double weight;
  @override
  final double suggestion;

  factory _$Exercise([void Function(ExerciseBuilder) updates]) =>
      (new ExerciseBuilder()..update(updates)).build();

  _$Exercise._(
      {this.plannedExerciseId, this.sets, this.weight, this.suggestion})
      : super._() {
    if (plannedExerciseId == null) {
      throw new BuiltValueNullFieldError('Exercise', 'plannedExerciseId');
    }
    if (sets == null) {
      throw new BuiltValueNullFieldError('Exercise', 'sets');
    }
    if (weight == null) {
      throw new BuiltValueNullFieldError('Exercise', 'weight');
    }
  }

  @override
  Exercise rebuild(void Function(ExerciseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciseBuilder toBuilder() => new ExerciseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exercise &&
        plannedExerciseId == other.plannedExerciseId &&
        sets == other.sets &&
        weight == other.weight &&
        suggestion == other.suggestion;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, plannedExerciseId.hashCode), sets.hashCode),
            weight.hashCode),
        suggestion.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Exercise')
          ..add('plannedExerciseId', plannedExerciseId)
          ..add('sets', sets)
          ..add('weight', weight)
          ..add('suggestion', suggestion))
        .toString();
  }
}

class ExerciseBuilder implements Builder<Exercise, ExerciseBuilder> {
  _$Exercise _$v;

  String _plannedExerciseId;
  String get plannedExerciseId => _$this._plannedExerciseId;
  set plannedExerciseId(String plannedExerciseId) =>
      _$this._plannedExerciseId = plannedExerciseId;

  ListBuilder<WorkoutSet> _sets;
  ListBuilder<WorkoutSet> get sets =>
      _$this._sets ??= new ListBuilder<WorkoutSet>();
  set sets(ListBuilder<WorkoutSet> sets) => _$this._sets = sets;

  double _weight;
  double get weight => _$this._weight;
  set weight(double weight) => _$this._weight = weight;

  double _suggestion;
  double get suggestion => _$this._suggestion;
  set suggestion(double suggestion) => _$this._suggestion = suggestion;

  ExerciseBuilder();

  ExerciseBuilder get _$this {
    if (_$v != null) {
      _plannedExerciseId = _$v.plannedExerciseId;
      _sets = _$v.sets?.toBuilder();
      _weight = _$v.weight;
      _suggestion = _$v.suggestion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exercise other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Exercise;
  }

  @override
  void update(void Function(ExerciseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Exercise build() {
    _$Exercise _$result;
    try {
      _$result = _$v ??
          new _$Exercise._(
              plannedExerciseId: plannedExerciseId,
              sets: sets.build(),
              weight: weight,
              suggestion: suggestion);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'sets';
        sets.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Exercise', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Workout extends Workout {
  @override
  final int date;
  @override
  final BuiltList<Exercise> exercises;
  @override
  final int rotationIndex;

  factory _$Workout([void Function(WorkoutBuilder) updates]) =>
      (new WorkoutBuilder()..update(updates)).build();

  _$Workout._({this.date, this.exercises, this.rotationIndex}) : super._() {
    if (date == null) {
      throw new BuiltValueNullFieldError('Workout', 'date');
    }
    if (exercises == null) {
      throw new BuiltValueNullFieldError('Workout', 'exercises');
    }
    if (rotationIndex == null) {
      throw new BuiltValueNullFieldError('Workout', 'rotationIndex');
    }
  }

  @override
  Workout rebuild(void Function(WorkoutBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkoutBuilder toBuilder() => new WorkoutBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Workout &&
        date == other.date &&
        exercises == other.exercises &&
        rotationIndex == other.rotationIndex;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, date.hashCode), exercises.hashCode),
        rotationIndex.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Workout')
          ..add('date', date)
          ..add('exercises', exercises)
          ..add('rotationIndex', rotationIndex))
        .toString();
  }
}

class WorkoutBuilder implements Builder<Workout, WorkoutBuilder> {
  _$Workout _$v;

  int _date;
  int get date => _$this._date;
  set date(int date) => _$this._date = date;

  ListBuilder<Exercise> _exercises;
  ListBuilder<Exercise> get exercises =>
      _$this._exercises ??= new ListBuilder<Exercise>();
  set exercises(ListBuilder<Exercise> exercises) =>
      _$this._exercises = exercises;

  int _rotationIndex;
  int get rotationIndex => _$this._rotationIndex;
  set rotationIndex(int rotationIndex) => _$this._rotationIndex = rotationIndex;

  WorkoutBuilder();

  WorkoutBuilder get _$this {
    if (_$v != null) {
      _date = _$v.date;
      _exercises = _$v.exercises?.toBuilder();
      _rotationIndex = _$v.rotationIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Workout other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Workout;
  }

  @override
  void update(void Function(WorkoutBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Workout build() {
    _$Workout _$result;
    try {
      _$result = _$v ??
          new _$Workout._(
              date: date,
              exercises: exercises.build(),
              rotationIndex: rotationIndex);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'exercises';
        exercises.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Workout', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
