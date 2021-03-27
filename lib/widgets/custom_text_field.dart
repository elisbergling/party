import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {
  const CustomTextField({
    Key key,
    this.text,
    this.isForm = false,
    this.isObscure = false,
    this.validator,
    this.onChanged,
    this.textEditingController,
  }) : super(key: key);

  final String text;
  final bool isForm;
  final bool isObscure;
  final Function validator;
  final Function onChanged;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: isForm
            ? TextFormField(
                controller: textEditingController,
                validator: validator,
                obscureText: isObscure,
                decoration: InputDecoration(
                  hintText: text,
                ),
              )
            : TextField(
                controller: textEditingController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: text,
                ),
              ),
      ),
    );
  }
}
