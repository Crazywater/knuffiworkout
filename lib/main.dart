import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/routes.dart';
import 'package:knuffiworkout/src/widgets/colors.dart' as colors;
import 'package:knuffiworkout/src/widgets/splash_screen.dart';

void main() {
  runApp(App());
}

/// The main Knuffiworkout app widget.
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final user = await _initializeUser();
    await initializeDb(user.uid);

    setState(() {
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) return SplashScreen();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colors.primarySwatch,
      ),
      routes: Map.fromIterable(directMappedRoutes,
          key: (route) => route.path, value: (route) => route.buildWidget),
      onGenerateRoute: _getRoute,
    );
  }

  Route<Null> _getRoute(RouteSettings settings) {
    final path = settings.name.split('/');
    if (path[0] != '') return null;
    if (path[1] == editScreen.path.substring(1)) {
      return MaterialPageRoute<Null>(
          settings: settings, builder: editScreen.pathParser(path.sublist(2)));
    }
    return null;
  }
}

Future<FirebaseUser> _initializeUser() async {
  final currentUser = await FirebaseAuth.instance.currentUser();
  if (currentUser != null) return currentUser;
  final googleSignIn = GoogleSignIn();
  var googleUser = await googleSignIn.signInSilently();
  if (googleUser == null) {
    googleUser = await googleSignIn.signIn();
  }
  final googleAuth = await googleUser.authentication;
  final credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
