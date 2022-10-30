import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/intransparent.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/widgets/edit_dialog.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/set_button.dart';
import 'package:knuffiworkout/src/widgets/set_group.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';
import 'package:knuffiworkout/src/workout/weight_widget.dart';

/// Widget to edit data about an exercise, consisting of:
///
/// * Information about the weight used for the exercise, if any
/// * An optional recommended weight
/// * The sets for the exercise with actual/planned reps, depending on whether
///   it is done already.
class ExerciseWidget extends StatelessWidget {
  final ExerciseWrapper exercise;

  /// Callback invoked when a [WorkoutSet] changes.
  ///
  /// [setIndex] is the index of [set] in the list of sets for the exercise.
  final void Function(int setIndex, WorkoutSet set) saveSet;
  final void Function(Exercise) saveExercise;
  final bool showsSuggestion;

  ExerciseWidget(this.exercise,
      {@required this.saveSet,
      @required this.saveExercise,
      this.showsSuggestion,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plannedExercise = exercise.plannedExercise;

    final header = <Widget>[
      Intransparent(Text(plannedExercise.name, style: headerTextStyle)),
    ];
    if (plannedExercise.hasWeight) {
      header.add(WeightWidget(exercise.exercise, saveExercise,
          showsSuggestion: showsSuggestion));
    }

    final sets = exercise.exercise.sets;

    return KnuffiCard(
        header: Row(
          children: header,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        children: [
          SetGroup(
            sets: [
              for (var i = 0; i < sets.length; i++)
                _renderSet(i, sets[i], context)
            ],
          ),
        ]);
  }

  Widget _renderSet(int index, WorkoutSet set, BuildContext context) =>
      SetButton(
        reps: set.completed ? set.actualReps : set.plannedReps,
        color: SetColor.forSet(set),
        onTap: () {
          final builder = set.toBuilder();
          builder.completed = !set.completed;
          if (builder.completed) {
            builder.actualReps = set.plannedReps;
          }
          saveSet(index, builder.build());
        },
        onLongPress: () => _onEditReps(index, set, context),
      );

  Future<void> _onEditReps(
      int index, WorkoutSet set, BuildContext context) async {
    final text =
        await showEditDialog('Edit reps', '${set.actualReps}', context);
    if (text == null) return;
    try {
      final newSet = set.rebuild((b) => b
        ..actualReps = int.parse(text)
        ..completed = true);
      saveSet(index, newSet);
    } on FormatException catch (_) {}
  }
}

/// Combines an [Exercise] with its [PlannedExercise].
class ExerciseWrapper {
  final Exercise exercise;
  final PlannedExercise plannedExercise;

  ExerciseWrapper(this.exercise, this.plannedExercise);
}
