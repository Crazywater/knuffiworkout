import 'dart:async';

import 'package:collection/collection.dart';
import 'package:knuffiworkout/src/storage/interface/event.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';
import 'package:knuffiworkout/src/storage/interface/storage.dart';

/// In-memory storage for use in testing.
///
/// The contents of this storage are deleted as the app exits.
class InMemoryStorage implements Storage {
  final _data = <String, dynamic>{};

  /// Sets the value of [path] to [value].
  ///
  /// If any map on the path doesn't exist, it is created empty.
  /// If [value] is `null`, the value is removed.
  ///
  /// Fires events for change, add and remove as a side-effect.
  void _set(List<String> path, dynamic value) {
    final map = _parent(path);
    if (value == null) {
      map[path.last].remove(value);
      _fireRemoval(path);
    } else {
      final isChange = map.containsKey(path.last);
      map[path.last] = value;
      (isChange ? _fireChange : _fireAdd)(path);
    }
    return value;
  }

  /// Creates all ancestors required to add data to [path].
  ///
  /// Returns the direct parent where the value can be inserted.
  Map<String, dynamic> _parent(List<String> path) {
    var map = _data;
    for (final part in path.take(path.length - 1)) {
      if (!map.containsKey(part)) {
        map[part] = <String, dynamic>{};
      }
      map = map[part];
    }
    return map;
  }

  /// Gets the value of [path].
  ///
  /// If any map on the path or the value itself doesn't exist, returns `null`.
  dynamic _get(List<String> path) {
    var value = _data;
    for (final part in path) {
      if (!value.containsKey(part)) return null;
      value = value[part];
    }
    return value;
  }

  void _fireRemoval(List<String> path) {
    _eventController.add(_Event.remove(path));
    if (path.length > 1) _fireChange(_parentPath(path));
  }

  void _fireAdd(List<String> path) {
    _eventController.add(_Event.add(path, _get(path)));
    if (path.length > 1) _fireChange(_parentPath(path));
  }

  void _fireChange(List<String> path) {
    _eventController.add(_Event.change(path, _get(path)));
    if (path.length > 1) _fireChange(_parentPath(path));
  }

  List<String> _parentPath(List<String> path) =>
      path.sublist(0, path.length - 1);

  Stream<_Event> get _events => _eventController.stream;
  final _eventController = StreamController<_Event>.broadcast();

  /// Reference to the root of this storage.
  InMemoryReference get root => InMemoryReference(this, []);
}

/// [InMemoryStorage] implementation of [Reference].
class InMemoryReference implements Reference {
  final InMemoryStorage _db;
  final List<String> _path;

  InMemoryReference(this._db, this._path);

  @override
  String get key => _path.last;

  @override
  InMemoryReference child(String child) =>
      InMemoryReference(_db, _path.toList()..addAll(child.split('/')));

  @override
  Stream<Event> get onChildAdded => _events(_EventType.add);

  @override
  Stream<Event> get onChildChanged => _events(_EventType.change);

  @override
  Stream<Event> get onChildRemoved => _events(_EventType.remove);

  @override
  Future<void> loadInitialData() async {}

  @override
  InMemoryReference push() {
    final key = ++_globalKey;
    return InMemoryReference(_db, _path.toList()..add('fake-$key'));
  }

  @override
  Future<void> remove() async {
    _db._set(_path, null);
    await Future(() {});
  }

  @override
  Future<void> set(dynamic value, {dynamic priority}) async {
    _db._set(_path, value);
    await Future(() {});
  }

  /// All events of type [type] that are for direct children of this reference.
  Stream<Event> _events(_EventType type) => _db._events
      .where((e) =>
          e.type == type &&
          e.path.length == _path.length + 1 &&
          ListEquality().equals(e.path.take(_path.length).toList(), _path))
      .map((e) => e.toEvent());
}

int _globalKey = 0;

/// A global event in the [InMemoryStorage].
class _Event {
  final _EventType type;

  /// Path that this event occurred on, inclusive.
  ///
  /// The last value of [path] is the key.
  final List<String> path;

  /// The new value, if [type] is [_EventType.add] or [_EventType.change].
  final dynamic value;

  _Event.add(List<String> path, dynamic value)
      : this._(_EventType.add, path, value);

  _Event.remove(List<String> path) : this._(_EventType.remove, path, null);

  _Event.change(List<String> path, dynamic value)
      : this._(_EventType.change, path, value);

  _Event._(this.type, this.path, this.value) {
    assert((value == null) == (type == _EventType.remove));
  }

  Event toEvent() => Event(Snapshot(path.last, value));
}

/// Type of an [_Event].
enum _EventType { add, remove, change }
