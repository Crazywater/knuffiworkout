/// An event that has occurred at a location in the database
/// (i.e. child added, removed, changed).
class Event {
  /// The [Snapshot] of data for this event.
  final Snapshot snapshot;

  Event(this.snapshot);
}

/// A snapshot of data for an [Event].
class Snapshot {
  /// The map key of this piece of data.
  final String key;

  /// The new value of the data, i.e.
  /// * The initial value if it's an add event, or
  /// * The new value if it's an update event, or
  /// * `null` if it's a delete event.
  final dynamic value;

  Snapshot(this.key, this.value);
}
