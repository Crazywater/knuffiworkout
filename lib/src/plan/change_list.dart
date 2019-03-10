import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/db/map_adapter.dart';
import 'package:knuffiworkout/src/widgets/stream_widget.dart';
import 'package:meta/meta.dart';

typedef Widget ItemToWidget<T>(BuildContext context, List<T> items, int index);

/// Renders a list from the contents of a [FireMap].
///
/// If the given [FireMap] grows in size, the list scrolls down to the end.
/// This is useful for views where the user can add items to the list.
class ChangeList<T> extends StatefulWidget {
  /// The items to render.
  final Stream<FireMap<T>> changes;

  /// Function that renders a single item in the [FireMap] as a [Widget].
  final ItemToWidget<T> widgetBuilder;

  ChangeList({@required this.changes, @required this.widgetBuilder});

  @override
  _ChangeListState<T> createState() => _ChangeListState<T>();
}

class _ChangeListState<T> extends State<ChangeList<T>> {
  final _scrollController = ScrollController();
  List<T> items;

  @override
  Widget build(BuildContext context) =>
      StreamWidget1<FireMap<T>>(widget.changes, _rebuild);

  Widget _rebuild(FireMap<T> snapshot, BuildContext context) {
    final newItems = snapshot.values.toList();
    bool scrollToEnd = items != null && newItems.length > items.length;
    items = newItems;

    if (scrollToEnd) {
      _triggerScrollToEnd();
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) =>
          widget.widgetBuilder(context, items, index),
      shrinkWrap: true,
      controller: _scrollController,
    );
  }

  Future<void> _triggerScrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _scrollController.animateTo(999999.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
