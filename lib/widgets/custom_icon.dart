import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon(this.icon, {Key key}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: babyWhite,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Icon(icon),
      ),
    );
  }
}
