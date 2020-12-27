import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({
    Key key,
    this.e,
    this.s,
  }) : super(key: key);

  final String e;
  final StackTrace s;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Text(e.toString() + s.toString()),
      ),
    );
  }
}
