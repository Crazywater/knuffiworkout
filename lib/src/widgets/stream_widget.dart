import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

/// Turns an object of type [A] into a [Widget].
typedef WidgetBuilder1<A> = Widget Function(A a, BuildContext context);

/// Turns two objects of type [A] and [B] into a [Widget].
typedef WidgetBuilder2<A, B> = Widget Function(A a, B b, BuildContext context);

/// Turns three objects of type [A], [B] and [C] into a [Widget].
typedef WidgetBuilder3<A, B, C> = Widget Function(
    A a, B b, C c, BuildContext context);

/// Listens to an [Observable] and turns its contents into a [Widget] using
/// the given [WidgetBuilder1].
///
/// Updates automatically whenever the [Observable] emits a new value.
class StreamWidget1<A> extends StatelessWidget {
  final Observable<A> _stream;
  final WidgetBuilder1<A> _builder;

  StreamWidget1(Stream<A> stream, WidgetBuilder1<A> builder)
      : this._(stream, builder);

  StreamWidget1._(this._stream, this._builder);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return LinearProgressIndicator();
        return _builder(snapshot.data, context);
      });
}

/// Listens to two [Observable]s and turns their contents into a [Widget] using
/// the given [WidgetBuilder2].
///
/// Updates automatically whenever the [Observable]s emit new values.
class StreamWidget2<A, B> extends StatelessWidget {
  final Observable<List> _combinedStream;
  final WidgetBuilder2<A, B> _builder;

  StreamWidget2(Stream<A> s1, Stream<B> s2, WidgetBuilder2<A, B> builder)
      : this._(
          Observable.combineLatest2(s1, s2, (e1, e2) => [e1, e2]),
          builder,
        );

  StreamWidget2._(this._combinedStream, this._builder);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _combinedStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return LinearProgressIndicator();
        return _builder(snapshot.data[0], snapshot.data[1], context);
      });
}

/// Listens to three [Observable]s and turns their contents into a [Widget]
/// using  the given [WidgetBuilder3].
///
/// Updates automatically whenever the [Observable]s emit new values.
class StreamWidget3<A, B, C> extends StatelessWidget {
  final Observable<List> _combinedStream;
  final WidgetBuilder3<A, B, C> _builder;

  StreamWidget3(
      Stream<A> s1, Stream<B> s2, Stream<C> s3, WidgetBuilder3<A, B, C> builder)
      : this._(
          Observable.combineLatest3(s1, s2, s3, (e1, e2, e3) => [e1, e2, e3]),
          builder,
        );

  StreamWidget3._(this._combinedStream, this._builder);

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: _combinedStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return LinearProgressIndicator();
        return _builder(
            snapshot.data[0], snapshot.data[1], snapshot.data[2], context);
      });
}
