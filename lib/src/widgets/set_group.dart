import 'package:flutter/widgets.dart';

/// Widget that displays group of multiple sets, e.g. in an exercise.
///
/// The sets are displayed in multiple rows of a [Wrap].
class SetGroup extends StatelessWidget {
  final List<Widget> sets;

  /// Alignment of a single row of sets.
  final WrapAlignment alignment;

  const SetGroup(
      {Key key,
      @required this.sets,
      this.alignment = WrapAlignment.spaceAround})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      children: sets,
      runSpacing: 12.0,
    );
  }
}
