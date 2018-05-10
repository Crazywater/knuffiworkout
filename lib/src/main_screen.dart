import 'package:flutter/material.dart';
import 'package:knuffiworkout/src/app_drawer.dart';
import 'package:knuffiworkout/src/db/exercise.dart' as exercise_db;
import 'package:knuffiworkout/src/db/rotation.dart' as rotation_db;
import 'package:knuffiworkout/src/plan/exercises_view.dart';
import 'package:knuffiworkout/src/plan/rotation_view.dart';
import 'package:knuffiworkout/src/progress/progress_view.dart';
import 'package:knuffiworkout/src/widgets/colors.dart';
import 'package:knuffiworkout/src/workout/current_view.dart';
import 'package:knuffiworkout/src/workout/past_view.dart';
import 'package:meta/meta.dart';

/// A screen that shows either the current workout or past workouts, selectable
/// via a drawer.
class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<_View> _views;
  List<DrawerItem> _drawerItems;
  _View _currentView;

  @override
  void initState() {
    super.initState();
    _views = <_View>[
      new _View(
        "Current workout",
        new _DrawerConfig(icon: Icons.assignment, hasDividerAfter: true),
        (_) => new CurrentView(),
      ),
      new _View(
        "Past workouts",
        new _DrawerConfig(icon: Icons.assignment_turned_in),
        (_) => new PastView(),
      ),
      new _View(
        "Progress",
        new _DrawerConfig(icon: Icons.equalizer, hasDividerAfter: true),
        (_) => new ProgressView(),
      ),
      new _View(
        "Exercises",
        new _DrawerConfig(icon: Icons.settings),
        (_) => new PlanExercisesView(),
        fabBuilder: (_) => renderFab(onPressed: () {
              exercise_db.createNew();
            }),
      ),
      new _View(
        "Rotation",
        new _DrawerConfig(icon: Icons.event),
        (_) => new RotationView(),
        fabBuilder: (_) => renderFab(onPressed: () {
              rotation_db.newDay();
            }),
      ),
    ];
    _drawerItems = _views.map(_createDrawerItem).toList();

    _currentView = _views.first;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(_currentView.title)),
        drawer: new AppDrawer(_drawerItems),
        body: _currentView.builder(context),
        floatingActionButton: _currentView.fabBuilder == null
            ? null
            : _currentView.fabBuilder(context));
  }

  DrawerItem _createDrawerItem(_View view) => new DrawerItem(
        view.drawerConfig.icon,
        view.title,
        onTap: () {
          setState(() {
            if (view == _currentView) return;
            _currentView = view;
            // Close the drawer.
            Navigator.pop(context);
          });
        },
        isSelected: view == _currentView,
        hasDividerAfter: view.drawerConfig.hasDividerAfter,
      );
}

/// A View in the [MainScreen].
class _View {
  final String title;
  final _DrawerConfig drawerConfig;
  final WidgetBuilder builder;
  final _FabBuilder fabBuilder;

  _View(this.title, this.drawerConfig, this.builder, {this.fabBuilder});
}

class _DrawerConfig {
  final IconData icon;
  final bool hasDividerAfter;

  _DrawerConfig({@required this.icon, this.hasDividerAfter = false});
}

FloatingActionButton renderFab({VoidCallback onPressed}) =>
    new FloatingActionButton(
        backgroundColor: fabColor,
        child: new Icon(Icons.add),
        onPressed: onPressed);

typedef FloatingActionButton _FabBuilder(BuildContext context);
