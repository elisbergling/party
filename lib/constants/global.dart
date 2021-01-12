import 'package:flutter/material.dart';

void showActionDialog({
  String title,
  String message,
  BuildContext ctx,
  dynamic service,
}) {
  showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          onPressed: () {
            service.error = '';
            Navigator.of(ctx).pop();
          },
          child: Text('Okay'),
        ),
      ],
    ),
  );
}
