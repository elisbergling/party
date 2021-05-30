import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/main.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key key, this.shouldNotJustPop = false})
      : super(key: key);

  final shouldNotJustPop;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.back,
        color: white,
      ),
      iconSize: 30,
      onPressed: shouldNotJustPop
          ? () =>
              Navigator.of(context).pushReplacementNamed(MyHomePage.routeName)
          : Navigator.of(context).pop,
    );
  }
}
