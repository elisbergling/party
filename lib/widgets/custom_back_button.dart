import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/main.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.shouldNotJustPop = false,
  });

  final bool shouldNotJustPop;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        CupertinoIcons.back,
        color: MyColors.white,
      ),
      iconSize: 30,
      onPressed: shouldNotJustPop
          ? () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              )
          : Navigator.of(context).pop,
    );
  }
}
