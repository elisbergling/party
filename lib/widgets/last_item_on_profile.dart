import 'package:flutter/material.dart';

class LastItemOnProfile extends StatelessWidget {
  const LastItemOnProfile({Key key, this.child, this.index, this.length})
      : super(key: key);

  final Widget child;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: index == length - 1 ? 55 : 0),
      child: child,
    );
  }
}
