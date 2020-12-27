import 'package:flutter/material.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyLoadingWidget(),
    );
  }
}
