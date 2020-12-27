import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/auth_service.dart';
import 'package:party/services/user_service.dart';
import 'package:party/widgets/custom_text_field.dart';

class AuthScreen extends HookWidget {
  const AuthScreen({Key key}) : super(key: key);

  void showErrorDialog({
    String message,
    BuildContext ctx,
    bool isAuth,
    AuthService authService,
    UserServiceCreateUser userServiceCreateUser,
  }) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              if (isAuth) {
                authService.error = '';
              } else {
                userServiceCreateUser.error = '';
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = useProvider(isLoginProvider);
    final auth = useProvider(authProvider);
    final userCreateUser = useProvider(userCreateUserProvider);
    final _formKey = GlobalKey<FormState>();
    final controllerName = useTextEditingController();
    final controllerUsername = useTextEditingController();
    final controllerEmail = useTextEditingController();
    final controllerPassword = useTextEditingController();
    final controllerConfirmPassword = useTextEditingController();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 750,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColorLight,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLogin.state) ...[
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
                        textEditingController: controllerConfirmPassword,
                      ),
                    auth.isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: () async {
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              if (isLogin.state) {
                                print('start');
                                await context.read(authProvider).loginWithEmail(
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
                                User user = await context
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
                                  await context
                                      .read(userCreateUserProvider)
                                      .createUser(
                                        uid: user.uid,
                                        email: user.email,
                                        name: controllerName.text,
                                        username: controllerUsername.text,
                                        imgUrl: '',
                                      );
                                  if (userCreateUser.error.isNotEmpty) {
                                    showErrorDialog(
                                      ctx: context,
                                      message: userCreateUser.error,
                                      isAuth: false,
                                      userServiceCreateUser: userCreateUser,
                                    );
                                  }
                                }
                              }
                            },
                            child: !isLogin.state
                                ? Text('Sign Up')
                                : Text('Login'),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (!auth.isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLogin.state
                      ? Text('Don\'t have an accont?')
                      : Text('Already have an accout?'),
                  const SizedBox(width: 20),
                  RaisedButton(
                    onPressed: () => isLogin.state = !isLogin.state,
                    child: isLogin.state ? Text('Sign Up') : Text('Login'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
