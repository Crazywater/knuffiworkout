import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/firebase_adapter.dart';
import 'package:knuffiworkout/src/db/rotation.dart' as rotation_db;
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/knuffi_card.dart';
import 'package:knuffiworkout/src/widgets/mini_fab.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';
import 'package:meta/meta.dart';

/// Renders a [Day] in the rotation configuration.
class DayWidget extends StatelessWidget {
  /// All [PlannedExercise]s.
  final FireMap<PlannedExercise> _exercises;

  /// Values of [_exercises], but sorted by name.
  ///
  /// This is used to render them in alphabetical order.
  final List<PlannedExercise> _sortedExercises;

  /// All [Day]s.
  final List<Day> _workouts;

  /// Index in [_workouts] to render.
  final int _index;

  /// Index in [_workouts] of the next exercise day.
  final int _nextRotationIndex;

  DayWidget(
      this._exercises, this._workouts, this._index, this._nextRotationIndex)
      : _sortedExercises = _exercises.values.toList()
          ..sort((left, right) => left.name.compareTo(right.name));

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < _day.plannedExerciseIds.length; i++) {
      final id = _day.plannedExerciseIds[i];
      children.add(_renderExercise(
        id,
        onChanged: (newId) {
          rotation_db
              .update(_day.rebuild((b) => b.plannedExerciseIds[i] = newId));
        },
        onRemoved: () {
          rotation_db
              .update(_day.rebuild((b) => b.plannedExerciseIds.removeAt(i)));
        },
      ));
    }
    children.add(new Row(
      children: [
        new MiniFab(onTap: () {
          rotation_db.update(_day
              .rebuild((b) => b.plannedExerciseIds.add(_exercises.keys.first)));
        }),
      ],
    ));

    bool isCurrent = _index == _nextRotationIndex;
    final title = isCurrent ? 'Day ${_index + 1} (next)' : 'Day ${_index + 1}';
    final headerStyle = isCurrent
        ? headerTextStyle.copyWith(fontWeight: FontWeight.bold)
        : headerTextStyle;
    return new KnuffiCard(
        header: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(title, style: headerStyle),
            new Row(children: [
              new IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () {
                  rotation_db.moveUp(_day);
                },
              ),
              new IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () {
                  rotation_db.moveDown(_day);
                },
              ),
              new IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  rotation_db.remove(_day);
                },
              )
            ]),
          ],
        ),
        children: children);
  }

  Widget _renderExercise(String exerciseId,
      {@required ValueChanged<String> onChanged,
      @required VoidCallback onRemoved}) {
    return new Row(
      children: [
        new DropdownButton<String>(
            value: exerciseId,
            items: _sortedExercises
                .map((exercise) => new DropdownMenuItem(
                    value: exercise.id, child: new Text(exercise.name)))
                .toList(),
            onChanged: onChanged),
        new IconButton(
          onPressed: onRemoved,
          icon: const Icon(Icons.close),
        )
      ],
    );
  }

  Day get _day => _workouts[_index];
}
