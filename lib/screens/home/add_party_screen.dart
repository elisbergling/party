import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

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
    final party = useProvider(partyProvider);
    final controllerName = useTextEditingController();
    final controllerAbout = useTextEditingController();
    final controllerPrice = useTextEditingController();
    //final controllerTime = useTextEditingController();
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
              validator: validator,
            ),
            CustomTextField(
              text: 'about',
              isForm: true,
              textEditingController: controllerAbout,
              validator: validator,
            ),
            CustomTextField(
              text: 'price(kr)',
              isForm: true,
              textEditingController: controllerPrice,
            ),
            /*
            CustomTextField(
              text: 'time',
              isForm: true,
              textEditingController: controllerTime,
            ),*/
            !party.isLoading
                ? RaisedButton(
                    onPressed: () async {
                      await context.read(partyProvider).addParty(
                            about: controllerAbout.text,
                            imgUrl: "",
                            name: controllerName.text,
                            price: int.parse(controllerPrice.text),
                            time: Timestamp.now(),
                          );
                      controllerName.text = '';
                      controllerAbout.text = '';
                      controllerPrice.text = '';
                    },
                    child: Text('add party'),
                  )
                : MyLoadingWidget(),
          ],
        ),
      ),
    );
  }
}
