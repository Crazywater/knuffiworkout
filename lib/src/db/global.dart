import 'package:firebase_database/firebase_database.dart';
import 'package:knuffiworkout/src/db/exercise.dart';
import 'package:knuffiworkout/src/db/rotation.dart';
import 'package:knuffiworkout/src/db/workout.dart';

/// The top level database, containing all of a user's data.
class Database {
  final ExerciseDb exercises;
  final RotationDb rotation;
  final WorkoutDb workouts;

  Database._(this.exercises, this.rotation, this.workouts);
}

/// The singleton instance of [Database].
///
/// Must call [initializeDb] before accessing.
Database get db => _db;
Database _db;

/// Initializes [db] for Firebase.
Future<void> initializeDb(String userId) async {
  await FirebaseDatabase.instance.setPersistenceEnabled(true);

  final rootRef = FirebaseDatabase.instance.reference();
  final userRef = rootRef.child('user/$userId');

  final exerciseRef = userRef.child('exercise');
  final rotationRef = userRef.child('rotation');
  final workoutRef = userRef.child('done');

  final exerciseDb = ExerciseDb(exerciseRef);
  await exerciseDb.initialize();

  final rotationDb = RotationDb(rotationRef, exerciseDb);
  await rotationDb.initialize();

  final workoutDb = WorkoutDb(workoutRef, exerciseDb, rotationDb);
  await workoutDb.initialize();

  _db = Database._(exerciseDb, rotationDb, workoutDb);
}
