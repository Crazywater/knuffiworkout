// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_view_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressViewModel extends ProgressViewModel {
  @override
  final ProgressMeasure measure;
  @override
  final String exerciseId;

  factory _$ProgressViewModel(
          [void Function(ProgressViewModelBuilder) updates]) =>
      (ProgressViewModelBuilder()..update(updates)).build();

  _$ProgressViewModel._({this.measure, this.exerciseId}) : super._() {
    if (measure == null) {
      throw BuiltValueNullFieldError('ProgressViewModel', 'measure');
    }
  }

  @override
  ProgressViewModel rebuild(void Function(ProgressViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressViewModelBuilder toBuilder() =>
      ProgressViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressViewModel &&
        measure == other.measure &&
        exerciseId == other.exerciseId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, measure.hashCode), exerciseId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ProgressViewModel')
          ..add('measure', measure)
          ..add('exerciseId', exerciseId))
        .toString();
  }
}

class ProgressViewModelBuilder
    implements Builder<ProgressViewModel, ProgressViewModelBuilder> {
  _$ProgressViewModel _$v;

  ProgressMeasure _measure;
  ProgressMeasure get measure => _$this._measure;
  set measure(ProgressMeasure measure) => _$this._measure = measure;

  String _exerciseId;
  String get exerciseId => _$this._exerciseId;
  set exerciseId(String exerciseId) => _$this._exerciseId = exerciseId;

  ProgressViewModelBuilder();

  ProgressViewModelBuilder get _$this {
    if (_$v != null) {
      _measure = _$v.measure;
      _exerciseId = _$v.exerciseId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressViewModel other) {
    if (other == null) {
      throw ArgumentError.notNull('other');
    }
    _$v = other as _$ProgressViewModel;
  }

  @override
  void update(void Function(ProgressViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ProgressViewModel build() {
    final _$result =
        _$v ?? _$ProgressViewModel._(measure: measure, exerciseId: exerciseId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
