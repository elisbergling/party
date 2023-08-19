import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';

class CustomTextField extends HookWidget {
  const CustomTextField({
    super.key,
    required this.text,
    this.textEditingController,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.icon,
    this.isForm = false,
    this.isObscure = false,
    this.color = MyColors.dark,
    this.margin = 10,
    this.borderRadius = 10,
    this.keyboardType = TextInputType.text,
  });

  final String text;
  final bool isForm;
  final bool isObscure;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? textEditingController;
  final Color color;
  final double margin;
  final double borderRadius;
  final TextInputType keyboardType;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: isForm
            ? TextFormField(
                controller: textEditingController,
                validator: validator,
                obscureText: isObscure,
                keyboardType: keyboardType,
                style: const TextStyle(color: MyColors.white),
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: const TextStyle(color: MyColors.grey),
                  filled: true,
                  fillColor: color,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              )
            : TextField(
                controller: textEditingController,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: const TextStyle(color: MyColors.white),
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: const TextStyle(color: MyColors.grey),
                  icon: icon != null ? Icon(icon, color: MyColors.blue) : null,
                ),
              ),
      ),
    );
  }
}
