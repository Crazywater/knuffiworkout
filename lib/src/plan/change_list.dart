import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffimap/knuffimap.dart';
import 'package:knuffimap/stream_widget.dart';
import 'package:meta/meta.dart';

/// Renders a list from the contents of a [KnuffiMap].
///
/// If the given [KnuffiMap] grows in size, the list scrolls down to the end.
/// This is useful for views where the user can add items to the list.
class ChangeList<T> extends StatefulWidget {
  /// The items to render.
  final Stream<KnuffiMap<T>> changes;

  /// Function that renders a single item in the [KnuffiMap] as a [Widget].
  final Widget Function(BuildContext context, List<T> items, int index)
      widgetBuilder;

  ChangeList({@required this.changes, @required this.widgetBuilder});

  @override
  _ChangeListState<T> createState() => _ChangeListState<T>();
}

class _ChangeListState<T> extends State<ChangeList<T>> {
  final _scrollController = ScrollController();
  List<T> items;

  @override
  Widget build(BuildContext context) =>
      StreamWidget1<KnuffiMap<T>>(widget.changes, _rebuild);

  Widget _rebuild(KnuffiMap<T> snapshot, BuildContext context) {
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
      padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
    );
  }

  Future<void> _triggerScrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _scrollController.animateTo(999999.0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
