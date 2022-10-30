/// Strips all data from the given [timestamp] that's more granular than the
/// day.
DateTime toDay(DateTime timestamp) =>
    DateTime(timestamp.year, timestamp.month, timestamp.day);
