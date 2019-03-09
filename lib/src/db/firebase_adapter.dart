import 'dart:async';
import 'dart:collection';

import 'package:collection/collection.dart' show lowerBound;
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef T Deserializer<T>(Map json);

/// Turns a Firebase [Query] into a [Stream] of sorted [FireMap]s.
///
/// This adapter subscribes to any changes on the given [Query] and keeps a
/// sorted mapping from [String] key to value in a [FireMap].
///
/// On every change, the [FireMap] is updated and [stream] emits the new
/// current state.
class FirebaseAdapter<T> {
  final _subject = BehaviorSubject<FireMap<T>>();
  final Query _query;
  final Deserializer<T> _deserializer;
  final Comparator<T> _comparator;

  List<StreamSubscription> _subscriptions;
  FireMap<T> _map;

  FirebaseAdapter(this._query, this._deserializer,
      {@required Comparator<T> comparator})
      : _comparator = comparator;

  /// An [Observable] which emits the full state of the [Query] in a [FireMap]
  /// on every change.
  ///
  /// This stream fires once on subscription with the current state, and then
  /// again on every change.
  Observable<FireMap<T>> get stream => _subject.stream;

  /// Starts listening on the given query.
  ///
  /// Emits the initial state in [stream].
  Future<void> open() async {
    assert(_subscriptions == null, "Already open!");

    _map = FireMap<T>(_comparator);

    _subscriptions = [
      _query.onChildAdded.listen((event) {
        _map._add(event.snapshot.key, _deserializer(event.snapshot.value));
        _subject.add(_map);
      }),
      _query.onChildChanged.listen((event) {
        _map._update(event.snapshot.key, _deserializer(event.snapshot.value));
        _subject.add(_map);
      }),
      _query.onChildRemoved.listen((event) {
        _map._remove(event.snapshot.key);
        _subject.add(_map);
      }),
      // Moves are ignored on purpose, we keep our own sort order.
    ];

    // Wait for initial load.
    await _query.once();
    _subject.add(_map);
  }

  /// Stops listening to updates on the [Query] and closes [stream].
  void close() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subject.close();
    _map = null;
  }
}

/// A read-only sorted map that is backed by Firebase.
class FireMap<T> {
  final _map = <String, T>{};
  final _sortedKeys = <String>[];
  final Comparator<T> _comparator;

  FireMap(this._comparator);

  void _add(String key, T value) {
    _map[key] = value;
    final index = lowerBound(_sortedKeys, key, compare: _keyComparator);
    _sortedKeys.insert(index, key);
  }

  void _remove(String key) {
    final index = lowerBound(_sortedKeys, key, compare: _keyComparator);
    _sortedKeys.removeAt(index);
    _map.remove(key);
  }

  void _update(String key, T value) {
    final oldIndex = lowerBound(_sortedKeys, key, compare: _keyComparator);
    _map[key] = value;
    final newIndex = lowerBound(_sortedKeys, key, compare: _keyComparator);
    if (oldIndex == newIndex) return;
    _sortedKeys.removeAt(oldIndex);
    _sortedKeys.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, key);
  }

  T operator [](String key) => _map[key];

  Iterable<String> get keys => UnmodifiableListView(_sortedKeys);

  Iterable<T> get values => _sortedKeys.map((key) => _map[key]);

  bool get isEmpty => _map.isEmpty;

  bool get isNotEmpty => _map.isNotEmpty;

  bool containsKey(String key) => _map.containsKey(key);

  void forEach(void Function(String key, T value) callback) {
    for (var key in _sortedKeys) {
      callback(key, this[key]);
    }
  }

  int _keyComparator(String left, String right) =>
      _comparator(this[left], this[right]);
}
