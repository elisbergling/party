import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({
    super.key,
    required this.e,
    required this.s,
  });

  final Object e;
  final StackTrace s;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Text(
          e.toString() + s.toString(),
          style: const TextStyle(
            color: MyColors.white,
          ),
        ),
      ),
    );
  }
}
