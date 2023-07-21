import 'package:flutter/material.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyLoadingWidget(),
    );
  }
}
