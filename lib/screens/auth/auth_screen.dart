import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/border_gradient.dart';
import 'package:party/widgets/custom_big_button.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_text_field.dart';

class AuthScreen extends HookConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(isLoginProvider);
    final auth = ref.watch(authProvider);
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
                            const SizedBox(height: 10),
                            if (!isLogin) ...[
                              CustomTextField(
                                text: 'name',
                                isForm: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
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
                                  if (value == null || value.isEmpty) {
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
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
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
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 8) {
                                  return 'Password is too short, must be atleast 8 characters';
                                }
                                return null;
                              },
                              textEditingController: controllerPassword,
                            ),
                            if (!isLogin)
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
                            if (auth.error.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: MyColors.dark,
                                ),
                                child: Center(
                                  child: Text(
                                    auth.error,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            CustomBigButton(
                              isLoading: auth.isLoading,
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  if (isLogin) {
                                    await ref
                                        .read(authProvider.notifier)
                                        .loginWithEmail(
                                          email: controllerEmail.text,
                                          password: controllerPassword.text,
                                        );
                                  } else {
                                    await ref
                                        .read(authProvider.notifier)
                                        .signUpWithEmail(
                                          email: controllerEmail.text,
                                          password: controllerPassword.text,
                                          name: controllerName.text,
                                          username: controllerUsername.text,
                                        );
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
