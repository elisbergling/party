import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/image_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/services/image_service.dart';
import 'package:party/services/user_service.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_close_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class UpdateUserInfoScreen extends HookWidget {
  const UpdateUserInfoScreen({
    Key key,
    this.name,
    this.username,
    this.imgUrl,
    this.uid,
  }) : super(key: key);

  final String name;
  final String username;
  final String imgUrl;
  final String uid;

  void selectImage(
    BuildContext context,
    ImageService image,
    UserService user,
    ImageSource source,
  ) async {
    await context.read(imageProvider).uploadFile(
          uid,
          source,
        );
    await context.read(userProvider).updateImgUrl(uid: uid);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(image.error.isNotEmpty || user.error.isNotEmpty
            ? image.error + user.error
            : 'Nothing went Wrong I guess'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerName = useTextEditingController(text: name);
    final controllerUsername = useTextEditingController(text: username);
    final image = useProvider(imageProvider);
    final user = useProvider(userProvider);
    return Container(
      height: 600,
      child: Scaffold(
        appBar: AppBar(
          leading: CustomCloseButton(),
          title: Text(
            'Update Your Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  builder: (context) => Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          text: 'image from library',
                          onTap: () => selectImage(
                              context, image, user, ImageSource.gallery),
                        ),
                        CustomButton(
                          text: 'image from camera',
                          onTap: () => selectImage(
                              context, image, user, ImageSource.camera),
                        ),
                      ],
                    ),
                  ),
                ),
                child: !user.isLoading && !image.isLoading
                    ? CachedImage(
                        imgUrl,
                        height: 100,
                        width: 100,
                        name: name,
                      )
                    : MyLoadingWidget(),
              ),
              const SizedBox(height: 25),
              CustomTextField(
                text: 'name',
                color: black,
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
                color: black,
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
              CustomButton(
                onTap: () async {
                  String error;
                  if (controllerUsername.text.isEmpty) {
                    error = 'Username can not be empty!';
                  } else if (controllerUsername.text.contains('\$') ||
                      controllerUsername.text.contains('-') ||
                      controllerUsername.text.contains('.') ||
                      controllerUsername.text.contains(' ')) {
                    error = 'Can not conatin such symbols';
                  }
                  if (controllerName.text.isEmpty) {
                    error = 'Well, you have to enter a name';
                  }
                  if (error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text(error),
                      ),
                    );
                    return;
                  }

                  await context.read(userProvider).updateUser(
                        name: controllerName.text,
                        username: controllerUsername.text,
                      );
                },
                text: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
