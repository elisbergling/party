import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';

class CustomButton extends HookWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 10));
    final padding = useState<double>(0.0);

    return GestureDetector(
      onTapDown: (details) {
        print('down');
        animationController.forward();
        padding.value = 1.0;
      },
      onTapUp: (details) {
        print('up');
        animationController.reverse();
        padding.value = 0.0;
      },
      onTap: () {
        onTap();
        // animationController.reverse();
        // animationController.forward();
      },
      child: AnimatedCustomButton(
        animation: Tween(begin: 10.0, end: 2.0).animate(animationController),
        text: text,
        padding: padding.value,
      ),
    );
  }
}

class AnimatedCustomButton extends AnimatedWidget {
  const AnimatedCustomButton({
    super.key,
    required Animation<double> animation,
    required this.text,
    required this.padding,
  }) : super(listenable: animation);

  final String text;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Container(
      padding: const EdgeInsets.all(0.6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.6),
        color: MyColors.blue,
      ),
      child: Material(
        elevation: animation.value,
        borderRadius: BorderRadius.circular(15),
        color: MyColors.black,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 10),
          padding: EdgeInsets.symmetric(
            vertical: 10 - padding,
            horizontal: 15 - padding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.blue.withOpacity(0.2),
          ),
          child: Text(
            text,
            style: const TextStyle(
                color: MyColors.blue, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
