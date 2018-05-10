import 'package:firebase_database/firebase_database.dart';

final _db = FirebaseDatabase.instance.reference();

DatabaseReference get userDb => _userDb;
DatabaseReference _userDb;

void setUserId(String userId) {
  _userDb = _db.child('user/$userId');
  _userDb.keepSynced(true);
}
