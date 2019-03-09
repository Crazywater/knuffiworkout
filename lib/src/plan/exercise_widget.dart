import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/formatter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/edit_dialog.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/mini_fab.dart';
import 'package:knuffiworkout/src/widgets/set_button.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';
import 'package:meta/meta.dart';

/// Renders a [PlannedExercise] in the exercise configuration.
class ExerciseWidget extends StatelessWidget {
  final PlannedExercise exercise;

  ExerciseWidget(this.exercise);

  @override
  Widget build(BuildContext context) {
    final header = _editableText(exercise.name,
        style: editableHeaderStyle, onTap: () => _editName(exercise, context));

    final setEditor = <Widget>[];
    for (var i = 0; i < exercise.sets.length; i++) {
      setEditor.add(_renderSet(exercise, i, context));
    }
    if (exercise.sets.length < 5) {
      setEditor.add(MiniFab(onTap: () {
        _addSet(exercise);
      }));
    }

    final editors = <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: setEditor,
      ),
      InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Weighted', style: mediumTextStyle),
            Checkbox(
              value: exercise.hasWeight,
              onChanged: (bool value) {
                _setWeighted(exercise, value);
              },
            ),
          ],
        ),
      )
    ];
    if (exercise.hasWeight) {
      final increaseText = 'Increase by ${formatWeight(exercise.increase)}';
      final decreaseText =
          'Decrease by ${formatPercent(exercise.decreaseFactor)}';
      editors.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _editableText(decreaseText, onTap: () {
              _editDecreaseFactor(exercise, context);
            }, style: editableMediumTextStyle),
            _editableText(increaseText, onTap: () {
              _editIncrease(exercise, context);
            }, style: editableMediumTextStyle),
          ],
        ),
      );
    }

    return KnuffiCard(
      header: header,
      children: editors,
    );
  }

  Widget _renderSet(PlannedExercise exercise, int index, BuildContext context) {
    final reps = exercise.sets[index].reps;
    return Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: SetButton(
            reps: reps,
            isElevated: true,
            onTap: () {
              _editReps(exercise, index, reps, context);
            }));
  }

  Widget _editableText(String text,
          {@required GestureTapCallback onTap, @required TextStyle style}) =>
      InkWell(child: Text(text, style: style), onTap: onTap);

  Future<void> _editName(PlannedExercise exercise, BuildContext context) async {
    final oldValue = exercise.name;
    final newValue = await showEditDialog('Rename exercise', oldValue, context,
        keyboardType: TextInputType.text);
    if (newValue == null || newValue.isEmpty || oldValue == newValue) return;
    await db.exercises.update(exercise.rebuild((b) => b..name = newValue));
  }

  Future<void> _addSet(PlannedExercise exercise) async {
    final lastSet = exercise.sets.last;
    await db.exercises.update(exercise
        .rebuild((b) => b..sets.add(PlannedSet((b) => b.reps = lastSet.reps))));
  }

  Future<void> _setWeighted(PlannedExercise exercise, bool value) async {
    await db.exercises.update(exercise.rebuild((b) => b.hasWeight = value));
  }

  Future<void> _editIncrease(
      PlannedExercise exercise, BuildContext context) async {
    final oldValue = exercise.increase;
    final newString = await showEditDialog(
        'Increase by', formatWeight(exercise.increase), context);
    if (newString == null) return;
    final newValue = double.tryParse(newString) ?? oldValue;
    await db.exercises.update(exercise.rebuild((b) => b.increase = newValue));
  }

  Future<void> _editDecreaseFactor(
      PlannedExercise exercise, BuildContext context) async {
    final newString = await showEditDialog(
        'Decrease by', formatPercentage(exercise.decreaseFactor), context,
        decoration: InputDecoration(suffixText: '%'));
    if (newString == null) return;
    var newValue = double.tryParse(newString) ?? 0.0;
    if (newValue > 100.0) newValue = 100.0;
    await db.exercises
        .update(exercise.rebuild((b) => b.decreaseFactor = newValue / 100.0));
  }

  Future<void> _editReps(PlannedExercise exercise, int index, int oldValue,
      BuildContext context) async {
    final newString = await showEditDialog('Reps', '$oldValue', context);
    if (newString == null) return;
    final newValue = int.tryParse(newString) ?? oldValue;
    if (newValue == oldValue) return;
    final builder = exercise.toBuilder();
    if (newValue <= 0) {
      if (exercise.sets.length > 1) {
        builder.sets.removeAt(index);
      } else {
        builder.sets[index] = builder.sets[index].rebuild((b) => b.reps = 1);
      }
    } else {
      builder.sets[index] =
          builder.sets[index].rebuild((b) => b.reps = newValue);
    }
    await db.exercises.update(builder.build());
  }
}
