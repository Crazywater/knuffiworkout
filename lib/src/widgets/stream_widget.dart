import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

typedef Widget WidgetBuilder1<A>(A a, BuildContext context);
typedef Widget WidgetBuilder2<A, B>(A a, B b, BuildContext context);
typedef Widget WidgetBuilder3<A, B, C>(A a, B b, C c, BuildContext context);

class StreamWidget1<A> extends StatelessWidget {
  final Observable<A> _stream;
  final WidgetBuilder1<A> _builder;

  StreamWidget1(Stream<A> stream, WidgetBuilder1<A> builder)
      : this._(stream, builder);

  StreamWidget1._(this._stream, this._builder);

  @override
  Widget build(BuildContext context) => new StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return new LinearProgressIndicator();
        return _builder(snapshot.data, context);
      });
}

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
  Widget build(BuildContext context) => new StreamBuilder(
      stream: _combinedStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return new LinearProgressIndicator();
        return _builder(snapshot.data[0], snapshot.data[1], context);
      });
}

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
  Widget build(BuildContext context) => new StreamBuilder(
      stream: _combinedStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return new LinearProgressIndicator();
        return _builder(
            snapshot.data[0], snapshot.data[1], snapshot.data[2], context);
      });
}
