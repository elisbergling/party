import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

void showActionDialog({
  required String title,
  required String message,
  required BuildContext ctx,
  required Function() onPressed,
}) {
  showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            onPressed;
            Navigator.of(ctx).pop();
          },
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}

String timeAGo({required Timestamp timestamp}) {
  DateTime dateTime = timestamp.toDate();
  return timeago.format(dateTime).replaceAll('ago', '');
}

String formatTimestamp({required Timestamp timestamp}) {
  DateTime dateTime = timestamp.toDate();
  String minute;
  if (dateTime.minute.toString().length == 1) {
    minute = '0${dateTime.minute}';
  } else {
    minute = dateTime.minute.toString();
  }
  return '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:$minute';
}
