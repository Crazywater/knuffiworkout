import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:meta/meta.dart';

/// Renders a set as a button.
class SetButton extends StatelessWidget {
  final int reps;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;
  final Color color;
  final bool isElevated;

  SetButton(
      {@required this.reps,
      this.color,
      this.onTap,
      this.onLongPress,
      this.isElevated = false});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? defaultSetColor;
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            '$reps',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: textColor(backgroundColor)),
          ),
        ),
      ),
    );
  }
}
