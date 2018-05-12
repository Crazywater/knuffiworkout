import 'dart:async';
import 'dart:math' as math;

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

/// A splash screen with an animation that is rendered while Firebase
/// initializes.
class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _animation =
        new CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final image = new DecoratedBox(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('assets/weight.png'),
        ),
      ),
    );

    return new DecoratedBox(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Padding(
        padding: new EdgeInsets.all(64.0),
        child: new AnimatedBuilder(
          animation: _animation,
          builder: (a, b) => new Transform(
                transform: new Matrix4.translationValues(
                    0.0, -100.0 * math.sin(math.pi * _animation.value), 0.0),
                alignment: Alignment.center,
                child: image,
              ),
        ),
      ),
    );
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
