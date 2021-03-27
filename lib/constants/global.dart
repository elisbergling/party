import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
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

String timeAGo({Timestamp timestamp}) {
  DateTime dateTime = timestamp.toDate();
  return timeago.format(dateTime);
}
