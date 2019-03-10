import 'package:firebase_database/firebase_database.dart';
import 'package:knuffiworkout/src/storage/firebase/reference.dart';
import 'package:knuffiworkout/src/storage/interface/reference.dart';
import 'package:knuffiworkout/src/storage/interface/storage.dart';

/// Firebase implementation of [Storage].
class FirebaseStorage implements Storage {
  @override
  Reference get root =>
      FirebaseReference(FirebaseDatabase.instance.reference());
}
