import 'dart:async';

import 'package:flutter/material.dart';

/// Show a popup dialog to edit a value.
///
/// Returns the entered value on close, `null` if editing was cancelled.
Future<String> showEditDialog(String title, String text, BuildContext context,
    {InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType = TextInputType.number}) async {
  final controller = TextEditingController(text: text)
    ..selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  final navigator = Navigator.of(context, rootNavigator: true);

  void submit([_]) {
    // Return controller text as return value of showDialog.
    navigator.pop(controller.text);
  }

  // TODO: Use TextAlign.right for numbers again when selection is fixed:
  // https://github.com/flutter/flutter/issues/17945
  final value = await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
          autofocus: true,
          controller: controller,
          keyboardType: keyboardType,
          onSubmitted: submit,
          decoration: decoration),
      actions: [
        TextButton(child: Text("OK"), onPressed: submit),
      ],
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
    ),
  );

  return value;
}
