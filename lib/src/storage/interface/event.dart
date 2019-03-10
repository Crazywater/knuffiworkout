class Event {
  final Snapshot snapshot;

  Event(this.snapshot);
}

class Snapshot {
  final String key;
  final dynamic value;

  Snapshot(this.key, this.value);
}
