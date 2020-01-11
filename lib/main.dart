import 'dart:async';

import 'package:flutter/material.dart';
import 'package:knuffimap/firebase/storage.dart';
import 'package:knuffimap/storage.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/routes.dart';
import 'package:knuffiworkout/src/login/firebase.dart';
import 'package:knuffiworkout/src/widgets/colors.dart' as colors;
import 'package:knuffiworkout/src/widgets/splash_screen.dart';

void main() {
  runApp(App(FirebaseStorage(), logInWithFirebase));
}

/// The main Knuffiworkout app widget.
class App extends StatefulWidget {
  final Storage storage;
  final Future<String> Function() logIn;

  const App(this.storage, this.logIn, {Key key}) : super(key: key);

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
    final userId = await widget.logIn();

    await initializeDb(userId, widget.storage.root);

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
      onGenerateRoute: _route,
    );
  }

  Route<void> _route(RouteSettings settings) {
    final path = settings.name.split('/');
    if (path[0] != '') return null;
    if (path[1] == editScreen.path.substring(1)) {
      return MaterialPageRoute<void>(
          settings: settings, builder: editScreen.pathParser(path.sublist(2)));
    }
    return null;
  }
}
