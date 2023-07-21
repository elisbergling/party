import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
  });
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: MyColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Icon(icon),
      ),
    );
  }
}
