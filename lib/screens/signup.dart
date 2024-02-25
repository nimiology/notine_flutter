import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:notine_flutter/helper/string_extension.dart';

import '../helper/auth_jwt_token_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import 'home.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool sending = false;
  String errorText = '';
  bool usernameError = false;
  bool passwordError = false;
  bool emailError = false;

  void changeSendingState() {
    setState(() {
      sending = !sending;
    });
  }

  Future login() async {
    if (!sending) {
      errorText = '';
      usernameError = false;
      passwordError = false;
      emailError = false;

      changeSendingState();

      final username = usernameController.text;
      final password = passwordController.text;
      final email = emailController.text;

      if (username.isNotEmpty &&
          password.isNotEmpty &&
          email.isNotEmpty ) {
        if (email.isValidEmail()) {
          try {
            http.Response response = await http.post(
                Uri.parse('https://notine.liara.run/auth/users/'),
                body: {
                  'username': username,
                  'email': email,
                  'password': password,
                });
            var tokensMap = json.decode(response.body);
            switch (response.statusCode) {
              case 201:
                {
                  try {
                    final http.Response response2 = await http.post(
                        Uri.parse(
                            'https://notine.liara.run/auth/jwt/create/'),
                        body: {'username': username, 'password': password});
                    final Map tokensMap = json.decode(response2.body);
                    switch (response2.statusCode) {
                      case 200:
                        {
                          await AuthToken.saveFromMap(tokensMap);
                          if (context.mounted) {
                            return Navigator.of(context)
                                .pushNamedAndRemoveUntil(HomeScreen.routeName,
                                    (Route<dynamic> route) => false);
                          }
                          break;
                        }
                      case 400:
                        {
                          for (String? key in tokensMap.keys) {
                            for (String? value in tokensMap[key]) {
                              errorText += '$key: $value \n';
                            }
                          }
                          break;
                        }
                      case 401:
                        {
                          for (String? key in tokensMap.keys) {
                            errorText += '$key: ${tokensMap[key]}';
                          }
                          break;
                        }
                    }
                  } on SocketException catch (_) {
                    errorText = "There is no internet connection";
                  } catch (e) {
                    errorText = "Something went wrong";
                  }
                  if (mounted) {
                    return Navigator.pop(context);
                  }
                  break;
                }
              case 400:
                {
                  for (String? key in tokensMap.keys) {
                    for (String? value in tokensMap[key]) {
                      errorText += '$key: $value \n';
                    }
                  }
                  break;
                }
              case 401:
                {
                  for (String? key in tokensMap.keys) {
                    errorText += '$key: ${tokensMap[key]}';
                  }
                }
            }
          } on SocketException catch (_) {
            errorText = "There is no internet connection";
          } catch (_) {
            errorText = "Something went wrong";
            rethrow;
          }
        } else {
          emailError = true;
          errorText = "Email is not valid.";
        }
      }

      if (username.isEmpty) {
        usernameError = true;
        errorText = "Fill the forms.";
      }
      if (password.isEmpty) {
        passwordError = true;
        errorText = "Fill the forms.";
      }
      if (email.isEmpty) {
        emailError = true;
        errorText = "Fill the forms.";
      }

      changeSendingState();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          children: [
            Container(
              margin: const EdgeInsets.only(left: 25, top: 40),
              alignment: Alignment.centerLeft,
              child:
                  Text('Create Account', style: theme.textTheme.headlineLarge),
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 100),
              alignment: Alignment.centerLeft,
              child: Text('Sync your notes',
                  style: theme.textTheme.titleSmall),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: usernameController,
              hintText: 'Username',
              enabled: !sending,
              error: usernameError,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              enabled: !sending,
              error: emailError,
            ),
            const SizedBox(height: 25),
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              enabled: !sending,
              error: passwordError,
              multiLine: false,
            ),
            const SizedBox(height: 25),
            errorText.isNotEmpty
                ? Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          errorText,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium!
                              .copyWith(color: theme.colorScheme.error),
                        )),
                  )
                : const SizedBox(height: 30),
            LoginButton(
                loading: sending, onPressed: login, title: 'Create Account'),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                LoginScreen.routeName,
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 25),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Already have an account? ',
                      ),
                      TextSpan(
                        text: ' Log in',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.primary),
                      ),
                    ],
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
