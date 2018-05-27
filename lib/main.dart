import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/global.dart' as db;
import 'package:knuffiworkout/src/db/rotation.dart' as rotation_db;
import 'package:knuffiworkout/src/db/workout.dart' as workout_db;
import 'package:knuffiworkout/src/routes.dart';
import 'package:knuffiworkout/src/widgets/colors.dart' as colors;
import 'package:knuffiworkout/src/widgets/splash_screen.dart';

void main() {
  runApp(new App());
}

/// The main Knuffiworkout app widget.
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AppState();
}

class _AppState extends State<App> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    final user = await _initializeUser();
    db.setUserId(user.uid);
    await FirebaseDatabase.instance.setPersistenceEnabled(true);

    await exercise_db.initialize();
    await rotation_db.initialize();
    await workout_db.initialize();
    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) return new SplashScreen();
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: colors.primarySwatch,
      ),
      routes: new Map.fromIterable(directMappedRoutes,
          key: (route) => route.path, value: (route) => route.buildWidget),
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final path = settings.name.split('/');
    if (path[0] != '') return null;
    if (path[1] == editScreen.path.substring(1)) {
      return new MaterialPageRoute<Null>(
          settings: settings, builder: editScreen.pathParser(path.sublist(2)));
    }
    return null;
  }
}

Future<FirebaseUser> _initializeUser() async {
  final currentUser = await FirebaseAuth.instance.currentUser();
  if (currentUser != null) return currentUser;
  final googleSignIn = new GoogleSignIn();
  var googleUser = await googleSignIn.signInSilently();
  if (googleUser == null) {
    googleUser = await googleSignIn.signIn();
  }
  final googleAuth = await googleUser.authentication;
  return await FirebaseAuth.instance.signInWithGoogle(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
}
