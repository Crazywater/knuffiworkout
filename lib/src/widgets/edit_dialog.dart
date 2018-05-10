import 'dart:async';

import 'package:flutter/material.dart';

/// Show a popup dialog to edit a value.
///
/// Returns the entered value on close, `null` if editing was cancelled.
Future<String> showEditDialog(String title, String text, BuildContext context,
    {InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.number}) async {
  final controller = new TextEditingController(text: text)
    ..selection = new TextSelection(baseOffset: 0, extentOffset: text.length);

  // Work-around: The context might get destroyed.
  final appState =
      context.ancestorStateOfType(const TypeMatcher<State<MaterialApp>>());

  void submit([_]) {
    // Return controller text as return value of showDialog.
    Navigator.of(appState.context).pop(controller.text);
  }

  final value = await showDialog(
    context: context,
    child: new _SystemPadding(
      child: new AlertDialog(
        title: new Text(title),
        content: new TextField(
            autofocus: true,
            controller: controller,
            keyboardType: keyboardType,
            onSubmitted: submit,
            decoration: decoration,
            textAlign: keyboardType == TextInputType.number
                ? TextAlign.end
                : TextAlign.start),
        actions: [
          new FlatButton(child: new Text("OK"), onPressed: submit),
        ],
        contentPadding: new EdgeInsets.symmetric(horizontal: 24.0),
      ),
    ),
  );

  return value;
}

// Fix for https://github.com/flutter/flutter/issues/7032.
class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
