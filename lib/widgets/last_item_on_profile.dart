import 'package:flutter/material.dart';

class LastItemOnProfile extends StatelessWidget {
  const LastItemOnProfile({
    super.key,
    required this.child,
    required this.index,
    required this.length,
  });

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
