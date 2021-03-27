import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_text_field.dart';

class UpdateUserInfoScreen extends HookWidget {
  const UpdateUserInfoScreen({
    Key key,
    this.name,
    this.username,
    this.imgUrl,
  }) : super(key: key);

  final String name;
  final String username;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final controllerName = useTextEditingController(text: name);
    final controllerUsername = useTextEditingController(text: username);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Your User Data'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 75),
            CachedImage(
              imgUrl,
              height: 250,
              width: 250,
              name: name,
            ),
            const SizedBox(height: 75),
            CustomTextField(
              text: 'name',
              isForm: true,
              textEditingController: controllerName,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Well, you have to enter a name';
                }
                return null;
              },
            ),
            CustomTextField(
              text: 'username',
              isForm: true,
              textEditingController: controllerUsername,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Username can not be empty!';
                } else if (value.contains('\$') ||
                    value.contains('-') ||
                    value.contains('.') ||
                    value.contains(' ')) {
                  return 'Can not conatin such symbols';
                }
                return null;
              },
            ),
            RaisedButton(
              onPressed: () async =>
                  await context.read(userProvider).updateUser(
                        name: controllerName.text,
                        username: controllerUsername.text,
                      ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
