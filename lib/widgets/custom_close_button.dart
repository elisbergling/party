import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        CupertinoIcons.clear,
        color: MyColors.white,
      ),
      iconSize: 24,
      onPressed: Navigator.of(context).pop,
    );
  }
}
