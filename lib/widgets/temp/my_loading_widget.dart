import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: CircularProgressIndicator(
          color: blue,
        ),
      ),
    );
  }
}
