import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/image_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/services/image_service.dart';
import 'package:party/services/user_service.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/custom_button.dart';
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
    final _formKey = GlobalKey<FormState>();
    final controllerName = useTextEditingController(text: name);
    final controllerUsername = useTextEditingController(text: username);
    final image = useProvider(imageProvider);
    final user = useProvider(userProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(),
          title: Text(
            'Update Your Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: dark,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 75),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: babyWhite,
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
                          height: 250,
                          width: 250,
                          name: name,
                        )
                      : MyLoadingWidget(),
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
                CustomButton(
                  onTap: () async =>
                      await context.read(userProvider).updateUser(
                            name: controllerName.text,
                            username: controllerUsername.text,
                          ),
                  text: 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}