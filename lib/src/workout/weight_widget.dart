import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/formatter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/edit_dialog.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';

typedef void ExerciseSaver(Exercise exercise);

/// A widget that shows the weight for an exercise, with an optional suggestion.
class WeightWidget extends StatelessWidget {
  final Exercise _exercise;
  final ExerciseSaver _saveCallback;
  final bool showsSuggestion;

  WeightWidget(this._exercise, this._saveCallback, {this.showsSuggestion});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      new Text('Weight: ${formatWeight(_exercise.weight)}',
          style: editableHeaderStyle)
    ];

    if (showsSuggestion && (_exercise.suggestion > 0.0)) {
      children
          .add(new Text('Suggestion: ${formatWeight(_exercise.suggestion)}'));
    }

    return new InkWell(
      onTap: () => _onEditWeight(_exercise, context),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  Future _onEditWeight(Exercise exercise, BuildContext context) async {
    final text = await showEditDialog(
        'Edit weight', '${formatWeight(exercise.weight)}', context);
    if (text == null) return;
    try {
      _saveCallback(exercise.rebuild((b) => b..weight = double.parse(text)));
    } on FormatException catch (_) {}
  }
}
