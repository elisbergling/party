import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class CustomBigButton extends HookWidget {
  const CustomBigButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.isLoading,
  });

  final Function() onTap;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 10));
    final padding = useState<double>(0.0);

    return GestureDetector(
      onTapDown: (details) {
        animationController.forward();
        padding.value = 1.0;
      },
      onTapUp: (details) {
        animationController.reverse();
        padding.value = 0.0;
      },
      onTap: !isLoading ? onTap : () {},
      child: AnimatedCustomBigButton(
        animation: Tween(begin: 10.0, end: 2.0).animate(animationController),
        text: text,
        padding: padding.value,
        isLoading: isLoading,
      ),
    );
  }
}

class AnimatedCustomBigButton extends AnimatedWidget {
  const AnimatedCustomBigButton({
    super.key,
    required Animation<double> animation,
    required this.text,
    required this.padding,
    required this.isLoading,
  }) : super(listenable: animation);

  final String text;
  final double padding;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(0.6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.6),
        color: isLoading ? MyColors.grey : MyColors.blue,
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
            color: isLoading
                ? MyColors.grey.withOpacity(0.2)
                : MyColors.blue.withOpacity(0.2),
          ),
          height: 60,
          child: Center(
            child: isLoading
                ? Transform.scale(
                    scale: 0.4,
                    child: const MyLoadingWidget(),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: MyColors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
