import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/widgets/background_gradient.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: dark,
            ),
          ),
        ),
      ),
    );
  }
}
