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
        TextButton(
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
  return timeago.format(dateTime).replaceAll('ago', '');
}

String formatTimestamp({Timestamp timestamp}) {
  DateTime dateTime = timestamp.toDate();
  String minute;
  if (dateTime.minute.toString().length == 1) {
    minute = '0' + dateTime.minute.toString();
  } else {
    minute = dateTime.minute.toString();
  }
  return dateTime.year.toString() +
      '/' +
      dateTime.month.toString() +
      '/' +
      dateTime.day.toString() +
      ' ' +
      dateTime.hour.toString() +
      ':' +
      minute;
}
