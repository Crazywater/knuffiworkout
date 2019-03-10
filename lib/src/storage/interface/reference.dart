import 'package:knuffiworkout/src/storage/interface/event.dart';

abstract class Reference {
  String get key;

  Reference child(String child);

  Stream<Event> get onChildAdded;

  Stream<Event> get onChildChanged;

  Stream<Event> get onChildRemoved;

  Future<Snapshot> once();

  Reference push();

  Future<void> remove();

  Future<void> update(Map<String, dynamic> value);

  Future<void> set(dynamic value, {dynamic priority});
}
