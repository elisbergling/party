import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';

class CustomButton extends HookWidget {
  const CustomButton({Key key, this.onTap, this.text}) : super(key: key);
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: Duration(milliseconds: 10));
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
        controller: animationController,
        text: text,
        padding: padding.value,
      ),
    );
  }
}

class AnimatedCustomButton extends AnimatedWidget {
  const AnimatedCustomButton({
    AnimationController controller,
    this.text,
    this.padding,
  }) : super(listenable: controller);

  final String text;
  final double padding;
  AnimationController get controller => listenable;

  @override
  Widget build(BuildContext context) {
    final animation = Tween(begin: 10.0, end: 2.0).animate(controller);
    return Container(
      padding: const EdgeInsets.all(0.6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.6),
        color: blue,
      ),
      child: Material(
        elevation: animation.value,
        borderRadius: BorderRadius.circular(15),
        color: black,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 10),
          padding: EdgeInsets.symmetric(
            vertical: 10 - padding,
            horizontal: 15 - padding,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: blue.withOpacity(0.2),
          ),
          child: Text(
            text,
            style: TextStyle(color: blue, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
