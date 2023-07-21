import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key, required this.child});

  final Scaffold child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.black,
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [test1, test1],
      //     tileMode: TileMode.clamp,
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     //stops: [-1, 1],
      //   ),
      // ),
      child: child,
    );
  }
}
