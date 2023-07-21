import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/auth_service.dart';
import 'package:party/services/user_service.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/border_gradient.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});

  void showErrorDialog({
    required String message,
    required BuildContext ctx,
    required bool isAuth,
    required AuthService authService,
    required UserServiceCreateUser userServiceCreateUser,
  }) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (isAuth) {
                authService.setError('');
              } else {
                userServiceCreateUser.setError('');
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(isLoginProvider);
    final auth = ref.watch(authProvider);
    final userCreateUser = ref.watch(userCreateUserProvider);
    final formKey = GlobalKey<FormState>();
    final controllerName = useTextEditingController();
    final controllerUsername = useTextEditingController();
    final controllerEmail = useTextEditingController();
    final controllerPassword = useTextEditingController();
    final controllerConfirmPassword = useTextEditingController();
    return BackgroundGradient(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: BorderGradient(
                    child: Container(
                      width: 750,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: MyColors.black,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              CustomTextField(
                                text: 'name',
                                isForm: true,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Well, you have to enter a name';
                                  }
                                  return null;
                                },
                                textEditingController: controllerName,
                              ),
                              CustomTextField(
                                text: 'username',
                                isForm: true,
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
                                textEditingController: controllerUsername,
                              )
                            ],
                            CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              text: 'email',
                              isForm: true,
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                                return null;
                              },
                              textEditingController: controllerEmail,
                            ),
                            CustomTextField(
                              keyboardType: TextInputType.visiblePassword,
                              text: 'password',
                              isForm: true,
                              isObscure: true,
                              validator: (value) {
                                if (value.isEmpty || value.length < 8) {
                                  return 'Password is too short, must be atleast 8 characters';
                                }
                                return null;
                              },
                              textEditingController: controllerPassword,
                            ),
                            if (!isLogin.state)
                              CustomTextField(
                                text: 'confirm password',
                                isForm: true,
                                isObscure: true,
                                validator: (value) {
                                  if (value != controllerPassword.text) {
                                    return 'Passwords does not match!';
                                  }
                                  return null;
                                },
                                textEditingController:
                                    controllerConfirmPassword,
                              ),
                            auth.isLoading
                                ? const MyLoadingWidget()
                                : CustomButton(
                                    onTap: () async {
                                      if (!formKey.currentState.validate()) {
                                        return;
                                      }
                                      formKey.currentState.save();
                                      if (isLogin) {
                                        print('start');
                                        await ref
                                            .read(authProvider)
                                            .loginWithEmail(
                                              email: controllerEmail.text,
                                              password: controllerPassword.text,
                                            );
                                        print('middle');
                                        if (auth.error.isNotEmpty) {
                                          showErrorDialog(
                                            ctx: context,
                                            message: auth.error,
                                            isAuth: true,
                                            authService: auth,
                                          );
                                        }
                                        print('finnish');
                                      } else {
                                        User user = await ref
                                            .read(authProvider)
                                            .signUpWithEmail(
                                              email: controllerEmail.text,
                                              password: controllerPassword.text,
                                            );
                                        if (auth.error.isNotEmpty) {
                                          showErrorDialog(
                                            ctx: context,
                                            message: auth.error,
                                            isAuth: true,
                                            authService: auth,
                                          );
                                        } else {
                                          await ref
                                              .read(userCreateUserProvider
                                                  .notifier)
                                              .createUser(
                                                uid: user.uid,
                                                email: user.email,
                                                name: controllerName.text,
                                                username:
                                                    controllerUsername.text,
                                                imgUrl: '',
                                              );
                                          if (userCreateUser.error.isNotEmpty) {
                                            showErrorDialog(
                                              ctx: context,
                                              message: userCreateUser.error,
                                              isAuth: false,
                                              userServiceCreateUser:
                                                  userCreateUser,
                                            );
                                          }
                                        }
                                      }
                                    },
                                    text: !isLogin ? 'Sign Up' : 'Login',
                                  ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (!auth.isLoading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLogin
                          ? const Text(
                              'Don\'t have an accont?',
                              style: TextStyle(color: MyColors.white),
                            )
                          : const Text(
                              'Already have an accout?',
                              style: TextStyle(color: MyColors.white),
                            ),
                      const SizedBox(width: 20),
                      CustomButton(
                        onTap: () =>
                            ref.read(isLoginProvider.notifier).state = !isLogin,
                        text: isLogin ? 'Sign Up' : 'Login',
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
