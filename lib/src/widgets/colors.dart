import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/model.dart';

/// Primary color of the app.
Color get primarySwatch => Colors.blue;

/// Border color for cards.
Color get borderColor => Colors.lightBlue;

/// Color for card titles.
Color get titleColor => primarySwatch;

/// Returns a suitable text color for the [background].
Color textColor(Color background) {
  if (background == Colors.transparent) return Colors.black;
  final luminance = background.computeLuminance();
  return luminance >= 0.45 ? Colors.black : Colors.white;
}

/// Color for the floating action button to add new items.
Color get fabColor => primarySwatch;

/// Color for the mini-version of the FAB.
Color get miniFabColor => primarySwatch;

/// Color for underlines of editable values.
Color get underlineColor => Colors.black26;

/// The different colors for representing a set.
class SetColor {
  /// Fill color of the set if rendered as a button.
  final Color fillColor;

  /// Border color of the set if rendered as a button.
  final Color strokeColor;

  /// Color to use in textual representation of this set.
  final Color textColor;

  /// The set was successful, at least as many reps as planned.
  static final success = SetColor._(Colors.lightGreen, null, Colors.lightGreen);

  /// The set failed, fewer reps than planned.
  static final failure = SetColor._(Colors.red[700], null, Colors.red[700]);

  /// The set was not attempted or we're in a configuration UI.
  static final none = SetColor._(null, Colors.black54, Colors.black38);

  SetColor._(this.fillColor, this.strokeColor, this.textColor);

  factory SetColor.forSet(WorkoutSet set) {
    if (!set.completed) return none;
    return set.actualReps < set.plannedReps ? failure : success;
  }
}
