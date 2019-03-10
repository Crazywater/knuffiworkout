import 'package:knuffiworkout/src/storage/interface/event.dart';

/// References a path in the hierarchical storage.
///
/// E.g. a reference could be to
/// * '/' to represent everything,
/// * '/user/123/workout' and represent all of user 123's workouts,
/// * '/user/123/workout/3' and represent a single workout.
abstract class Reference {
  /// The key of this reference in its map.
  String get key;

  /// Creates a [Reference] to the child map.
  ///
  /// The path may contain slashes to represent descendants further down.
  Reference child(String path);

  /// Fired whenever a child entry has been added.
  Stream<Event> get onChildAdded;

  /// Fired whenever a child entry of this reference has changed.
  Stream<Event> get onChildChanged;

  /// Fired whenever a child entry of this reference is removed.
  Stream<Event> get onChildRemoved;

  /// Makes sure all data for this reference is loaded.
  Future<void> loadInitialData();

  /// Creates a new child reference with a random, no-collision key.
  Reference push();

  /// Removes this child from its parent.
  Future<void> remove();

  /// Sets the value of this child to [value].
  Future<void> set(Map<String, dynamic> value);
}
