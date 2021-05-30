import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.clear,
        color: white,
      ),
      iconSize: 24,
      onPressed: Navigator.of(context).pop,
    );
  }
}
