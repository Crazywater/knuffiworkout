import 'package:flutter/material.dart';
import 'package:knuffimap/knuffimap.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/widgets/intransparent.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/mini_fab.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';

/// Renders a [Day] in the rotation configuration.
class DayWidget extends StatelessWidget {
  /// All [PlannedExercise]s.
  final KnuffiMap<PlannedExercise> _exercises;

  /// Values of [_exercises], but sorted by name.
  ///
  /// This is used to render them in alphabetical order.
  final List<PlannedExercise> _sortedExercises;

  /// All [Day]s.
  final List<Day> _days;

  /// Index in [_days] to render.
  final int _index;

  /// Index in [_days] of the next exercise day.
  final int _nextRotationIndex;

  DayWidget(this._exercises, this._days, this._index, this._nextRotationIndex)
      : _sortedExercises = _exercises.values.toList()
          ..sort((left, right) => left.name.compareTo(right.name));

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _day.plannedExerciseIds.length; i++) {
      final id = _day.plannedExerciseIds[i];
      children.add(_renderExercise(
        id,
        onChanged: (newId) async {
          await db.rotation
              .update(_day.rebuild((b) => b.plannedExerciseIds[i] = newId));
          db.workouts.planExerciseChanged(_index, i, newId);
        },
        onRemoved: () async {
          await db.rotation
              .update(_day.rebuild((b) => b.plannedExerciseIds.removeAt(i)));
          db.workouts.planExerciseRemoved(_index, i);
        },
      ));
    }
    children.add(Row(
      children: [
        MiniFab(onTap: () async {
          final exerciseId = _exercises.keys.first;
          await db.rotation.update(
              _day.rebuild((b) => b.plannedExerciseIds.add(exerciseId)));
          db.workouts.planExerciseAdded(_index, exerciseId);
        }),
      ],
    ));

    bool isNext = _index == _nextRotationIndex;
    final title = isNext ? 'Day ${_index + 1} (next)' : 'Day ${_index + 1}';
    final headerStyle = isNext
        ? headerTextStyle.copyWith(fontWeight: FontWeight.bold)
        : headerTextStyle;
    return KnuffiCard(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Intransparent(Text(title, style: headerStyle)),
            Intransparent(Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                color: titleColor,
                onPressed: () {
                  db.rotation.moveUp(_day);
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                color: titleColor,
                onPressed: () {
                  db.rotation.moveDown(_day);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: titleColor,
                onPressed: () {
                  db.rotation.remove(_day);
                },
              )
            ])),
          ],
        ),
        headerHeight: 48.0,
        children: children);
  }

  Widget _renderExercise(String exerciseId,
      {@required ValueChanged<String> onChanged,
      @required void Function() onRemoved}) {
    return Row(
      children: [
        DropdownButton<String>(
            value: exerciseId,
            items: _sortedExercises
                .map((exercise) => DropdownMenuItem(
                    value: exercise.id, child: Text(exercise.name)))
                .toList(),
            onChanged: onChanged),
        IconButton(
          onPressed: onRemoved,
          icon: const Icon(Icons.close),
        )
      ],
    );
  }

  Day get _day => _days[_index];
}
