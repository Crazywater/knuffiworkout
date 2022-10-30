import 'dart:async';

import 'package:flutter/material.dart';

/// Show a popup dialog to confirm an action.
///
/// Returns `true` if the user confirmed the action, false otherwise.
Future<bool> showConfirmationDialog({
  @required BuildContext context,
  @required String title,
  @required String text,
  String confirmButtonText = 'OK',
  String cancelButtonText = 'CANCEL',
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);

  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Padding(padding: EdgeInsets.only(top: 8.0), child: Text(text)),
      actions: [
        TextButton(
            child: Text(confirmButtonText),
            onPressed: () => navigator.pop(true)),
        TextButton(
            child: Text(cancelButtonText),
            onPressed: () => navigator.pop(false)),
      ],
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
    ),
  );
}
