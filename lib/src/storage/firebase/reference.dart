import 'package:firebase_database/firebase_database.dart' as firebase;
import 'package:knuffiworkout/src/storage/interface/event.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';

/// Firebase implementation of [Reference].
class FirebaseReference implements Reference {
  final firebase.DatabaseReference _ref;

  FirebaseReference(this._ref);

  @override
  Reference child(String path) => FirebaseReference(_ref.child(path));

  @override
  String get key => _ref.key;

  @override
  Stream<Event> get onChildAdded => _ref.onChildAdded.map(_toEvent);

  @override
  Stream<Event> get onChildChanged => _ref.onChildChanged.map(_toEvent);

  @override
  Stream<Event> get onChildRemoved => _ref.onChildRemoved.map(_toEvent);

  @override
  Future<void> loadInitialData() => _ref.once();

  @override
  FirebaseReference push() => FirebaseReference(_ref.push());

  @override
  Future<void> remove() => _ref.remove();

  @override
  Future<void> set(Map<String, dynamic> value) => _ref.set(value);

  Event _toEvent(firebase.Event e) => Event(_toSnapshot(e.snapshot));

  Snapshot _toSnapshot(firebase.DataSnapshot s) => Snapshot(s.key, s.value);
}
