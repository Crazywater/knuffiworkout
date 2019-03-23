import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/widgets/rounded_rectangle.dart';
import 'package:meta/meta.dart';

/// Renders a set as a button.
class SetButton extends StatelessWidget {
  final int reps;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;
  final SetColor color;

  SetButton(
      {@required this.reps,
      @required this.color,
      this.onTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return RoundedRectangle(
      onTap: onTap,
      onLongPress: onLongPress,
      strokeColor: color.strokeColor,
      fillColor: color.fillColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          '$reps',
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: color.fillColor == null
                  ? Colors.black
                  : textColor(color.fillColor)),
        ),
      ),
    );
  }
}
