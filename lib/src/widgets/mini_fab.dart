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
  Widget build(BuildContext context) => new Material(
        color: color ?? primarySwatch,
        type: MaterialType.circle,
        elevation: 8.0,
        child: new InkWell(
          onTap: onTap,
          child: new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: new Text(
              '+',
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      );
}
