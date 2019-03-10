import 'package:knuffiworkout/src/storage/interface/reference.dart';

/// Interface for a backend storage.
///
/// Storage is modeled closely after Firebase, as a hierarchical map of maps.
/// For more details, see the documentation on [Reference].
abstract class Storage {
  /// Returns a [Reference] to the root of the storage.
  Reference get root;
}
