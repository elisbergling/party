import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: MyColors.blue,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
