import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Center(
        child: CircularProgressIndicator(
          color: MyColors.blue,
        ),
      ),
    );
  }
}
