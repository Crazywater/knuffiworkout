import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

/// Signs in the user for Firebase using Google sign in.
///
/// Returns the signed-in Firebase user id.
/// If they're already signed in, nothing happens and the user ID is recycled.
Future<String> logInWithFirebase() async {
  final currentUser = await firebase.FirebaseAuth.instance.currentUser();
  if (currentUser != null) return currentUser.uid;

  final googleSignIn = GoogleSignIn();
  var googleUser = await googleSignIn.signInSilently();
  if (googleUser == null) {
    googleUser = await googleSignIn.signIn();
  }
  final googleAuth = await googleUser.authentication;
  final credential = firebase.GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  final user =
      await firebase.FirebaseAuth.instance.signInWithCredential(credential);
  return user.uid;
}
