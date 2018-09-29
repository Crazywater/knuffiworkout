import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:meta/meta.dart';

/// A mini-version of the floating action button.
///
/// Used to add things inline.
class MiniFab extends StatelessWidget {
  final Color color;
  final GestureTapCallback onTap;

  MiniFab({this.color, @required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
        color: color ?? primarySwatch,
        type: MaterialType.circle,
        elevation: 8.0,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              '+',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      );
}
