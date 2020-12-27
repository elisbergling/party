import 'package:flutter/material.dart';
import 'package:party/widgets/temp/my_error_widget.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    Key key,
    this.e,
    this.s,
  }) : super(key: key);

  final String e;
  final StackTrace s;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyErrorWidget(e: e, s: s),
    );
  }
}
