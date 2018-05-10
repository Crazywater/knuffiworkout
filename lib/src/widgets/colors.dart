import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/model.dart';

/// Primary color of the app.
Color get primarySwatch => Colors.blue;

/// The color for a [WorkoutSet], depending on whether it was successful.
Color getSetColor(WorkoutSet set) {
  if (set.completed) {
    return set.actualReps < set.plannedReps
        ? Colors.red[200]
        : Colors.lightGreen;
  }
  return defaultSetColor;
}

/// Default set color for uncompleted sets.
Color get defaultSetColor => Colors.grey[300];

/// Color for the floating action button to add new items.
Color get fabColor => Colors.red;

/// Color for underlines of editable values.
Color get underlineColor => Colors.black26;
