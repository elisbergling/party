import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/widgets/custom_text_field.dart';

class AddPartyScreen extends HookWidget {
  const AddPartyScreen({
    Key key,
  }) : super(key: key);

  String validator(value) {
    if (value.isEmpty) {
      return 'Well, you have to enter a name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controllerName = useTextEditingController();
    final controllerAbout = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final controllerLocation = useTextEditingController();
    final controllerTime = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('new partrry'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              text: 'name',
              isForm: true,
              textEditingController: controllerName,
              validator: (value) => validator(value),
            ),
            CustomTextField(
              text: 'about',
              isForm: true,
              textEditingController: controllerAbout,
              validator: (value) => validator(value),
            ),
            CustomTextField(
              text: 'price',
              isForm: true,
              textEditingController: controllerPrice,
            ),
            CustomTextField(
              text: 'location',
              isForm: true,
              textEditingController: controllerLocation,
            ),
            CustomTextField(
              text: 'time',
              isForm: true,
              textEditingController: controllerTime,
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('add party'),
            ),
          ],
        ),
      ),
    );
  }
}
