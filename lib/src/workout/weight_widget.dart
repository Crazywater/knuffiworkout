import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/formatter.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/intransparent.dart';
import 'package:knuffiworkout/src/widgets/edit_dialog.dart';
import 'package:knuffiworkout/src/widgets/typography.dart';

/// A widget that shows the weight for an exercise, with an optional suggestion.
class WeightWidget extends StatelessWidget {
  /// [Exercise] for which to render the weight.
  final Exercise _exercise;

  /// Saves the [Exercise] when the weight is changed.
  final void Function(Exercise) _saveCallback;

  /// Whether to show the suggested weight of [_exercise].
  final bool showsSuggestion;

  WeightWidget(this._exercise, this._saveCallback, {this.showsSuggestion});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Intransparent(
        Text('Weight: ${formatWeight(_exercise.weight)}',
            style: editableHeaderStyle),
      )
    ];

    if (showsSuggestion && (_exercise.suggestion > 0.0)) {
      children.add(Text('Suggestion: ${formatWeight(_exercise.suggestion)}'));
    }

    return InkWell(
      onTap: () => _onEditWeight(_exercise, context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  Future<void> _onEditWeight(Exercise exercise, BuildContext context) async {
    final text = await showEditDialog(
        'Edit weight', '${formatWeight(exercise.weight)}', context);
    if (text == null) return;
    try {
      _saveCallback(exercise.rebuild((b) => b..weight = double.parse(text)));
    } on FormatException catch (_) {}
  }
}
