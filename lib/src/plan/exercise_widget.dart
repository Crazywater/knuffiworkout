import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/formatter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/edit_dialog.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/mini_fab.dart';
import 'package:knuffiworkout/src/widgets/set_button.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';
import 'package:meta/meta.dart';

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
      setEditor.add(new MiniFab(onTap: () {
        _addSet(exercise);
      }));
    }

    final editors = <Widget>[
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: setEditor,
      ),
      new InkWell(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Text('Weighted', style: mediumTextStyle),
            new Checkbox(
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
      final increaseText = 'Increase by ${formatWeight(
          exercise.increase)}';
      final decreaseText = 'Decrease by ${formatPercent(
          exercise.decreaseFactor)}';
      editors.add(
        new Row(
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

    return new KnuffiCard(
      header: header,
      children: editors,
    );
  }

  Widget _renderSet(PlannedExercise exercise, int index, BuildContext context) {
    final reps = exercise.sets[index].reps;
    return new Padding(
        padding: new EdgeInsets.only(right: 8.0),
        child: new SetButton(
            reps: reps,
            isElevated: true,
            onTap: () {
              _editReps(exercise, index, reps, context);
            }));
  }

  Widget _editableText(String text,
          {@required GestureTapCallback onTap, @required TextStyle style}) =>
      new InkWell(child: new Text(text, style: style), onTap: onTap);

  Future _editName(PlannedExercise exercise, BuildContext context) async {
    final oldValue = exercise.name;
    final newValue = await showEditDialog('Rename exercise', oldValue, context,
        keyboardType: TextInputType.text);
    if (newValue == null || newValue.isEmpty || oldValue == newValue) return;
    await exercise_db.update(exercise.rebuild((b) => b..name = newValue));
  }

  Future _addSet(PlannedExercise exercise) async {
    final lastSet = exercise.sets.last;
    await exercise_db.update(exercise.rebuild(
        (b) => b..sets.add(new PlannedSet((b) => b.reps = lastSet.reps))));
  }

  Future _setWeighted(PlannedExercise exercise, bool value) async {
    await exercise_db.update(exercise.rebuild((b) => b.hasWeight = value));
  }

  Future _editIncrease(PlannedExercise exercise, BuildContext context) async {
    final oldValue = exercise.increase;
    final newString = await showEditDialog(
        'Increase by', formatWeight(exercise.increase), context);
    if (newString == null) return;
    final newValue = double.parse(newString, (_) => oldValue);
    await exercise_db.update(exercise.rebuild((b) => b.increase = newValue));
  }

  Future _editDecreaseFactor(
      PlannedExercise exercise, BuildContext context) async {
    final newString = await showEditDialog(
        'Decrease by', formatPercentage(exercise.decreaseFactor), context,
        decoration: new InputDecoration(suffixText: '%'));
    if (newString == null) return;
    var newValue = double.parse(newString, (_) => 0.0);
    if (newValue > 100.0) newValue = 100.0;
    await exercise_db
        .update(exercise.rebuild((b) => b.decreaseFactor = newValue / 100.0));
  }

  Future _editReps(PlannedExercise exercise, int index, int oldValue,
      BuildContext context) async {
    final newString = await showEditDialog('Reps', '$oldValue', context);
    if (newString == null) return;
    final newValue = int.parse(newString, onError: (_) => oldValue);
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
    await exercise_db.update(builder.build());
  }
}
