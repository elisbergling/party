import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';

class CustomTextField extends HookWidget {
  const CustomTextField({
    Key key,
    this.text,
    this.isForm = false,
    this.isObscure = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textEditingController,
    this.color = dark,
    this.margin = 20,
    this.borderRadius = 10,
    this.keyboardType = TextInputType.text,
    this.icon,
  }) : super(key: key);

  final String text;
  final bool isForm;
  final bool isObscure;
  final Function validator;
  final Function onChanged;
  final Function onSubmitted;
  final TextEditingController textEditingController;
  final Color color;
  final double margin;
  final double borderRadius;
  final TextInputType keyboardType;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: isForm
            ? TextFormField(
                controller: textEditingController,
                validator: validator,
                obscureText: isObscure,
                keyboardType: keyboardType,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: TextStyle(color: grey),
                ),
              )
            : TextField(
                controller: textEditingController,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: TextStyle(color: grey),
                  icon: icon != null ? Icon(icon, color: blue) : null,
                ),
              ),
      ),
    );
  }
}
