import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Signs in the user for Firebase using Google sign in.
///
/// Returns the signed-in Firebase user id.
/// If they're already signed in, nothing happens and the user ID is recycled.
Future<String> logInWithFirebase() async {
  await Firebase.initializeApp();
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) return currentUser.uid;

  final googleSignIn = GoogleSignIn();
  var googleUser = await googleSignIn.signInSilently();
  if (googleUser == null) {
    googleUser = await googleSignIn.signIn();
  }
  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  final result = await FirebaseAuth.instance.signInWithCredential(credential);
  return result.user.uid;
}
