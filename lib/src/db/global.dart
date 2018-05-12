import 'package:firebase_database/firebase_database.dart';

/// Top level reference to the entire Firebase DB.
final _db = FirebaseDatabase.instance.reference();

/// Reference to the user's portion of the Firebase database.
DatabaseReference get userDb => _userDb;
DatabaseReference _userDb;

/// Initializes the user database with the given [userId].
void setUserId(String userId) {
  _userDb = _db.child('user/$userId');
  _userDb.keepSynced(true);
}
