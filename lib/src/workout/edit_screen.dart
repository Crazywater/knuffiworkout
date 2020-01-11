import 'package:flutter/material.dart';
import 'package:knuffimap/knuffimap.dart';
import 'package:knuffimap/stream_widget.dart';
import 'package:knuffiworkout/src/db/global.dart';
import 'package:knuffiworkout/src/model.dart';
import 'package:knuffiworkout/src/widgets/confirmation_dialog.dart';
import 'package:knuffiworkout/src/workout/workout_editor.dart';

/// Screen for editing a workout.
class EditScreen extends StatefulWidget {
  /// Key of the workout to be edited.
  final String _key;

  EditScreen(this._key, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditScreenState();
}

/// State for [EditScreen].
class EditScreenState extends State<EditScreen> {
  static final appBarTitle = 'Edit workout';

  /// Whether the workout is currently in the process of being deleted.
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return _isDeleting
        ? _buildLoadingScreen()
        : StreamWidget1(db.workouts.stream, _rebuild);
  }

  Widget _rebuild(KnuffiMap<Workout> workouts, BuildContext context) {
    final workout = workouts[widget._key];
    final appBarActions = [
      PopupMenuButton<void>(
        itemBuilder: (context) => [
          PopupMenuItem(value: Object(), child: Text('Delete workout')),
        ],
        onSelected: (_) {
          _deleteWorkout(context);
        },
      )
    ];
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), actions: appBarActions),
      body: WorkoutEditor(widget._key, workout),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _deleteWorkout(BuildContext context) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    final shouldDelete = await showConfirmationDialog(
      context: context,
      title: 'Really delete workout?',
      text: "This will delete your workout entirely and can't be undone.",
      confirmButtonText: 'DELETE',
    );

    if (!shouldDelete) return;

    setState(() {
      _isDeleting = true;
    });

    await db.workouts.delete(widget._key);
    navigator.pop();
  }
}
