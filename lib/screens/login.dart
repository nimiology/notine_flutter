import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import 'forgot_password.dart';
import 'home.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool sending = false;
  String errorText = '';
  bool usernameError = false;
  bool passwordError = false;

  void changeSendingState() {
    setState(() {
      sending = !sending;
    });
  }

  Future login() async {
    if (!sending) {
      setState(() {
        errorText = '';
        usernameError = false;
        passwordError = false;
      });
      errorText = '';

      changeSendingState();

      final username = usernameController.text;
      final password = passwordController.text;

      if (username.isNotEmpty && password.isNotEmpty) {
        try {
          http.Response response = await http.post(
              Uri.parse('https://notine.liara.run/auth/jwt/create/'),
              body: {'username': username, 'password': password});
          var tokensMap = json.decode(response.body);
          switch (response.statusCode) {
            case 200:
              {
                AuthToken.saveFromMap(tokensMap);
                if (context.mounted) {
                  return Navigator.popAndPushNamed(
                      context, HomeScreen.routeName);
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
        } catch (e) {
          errorText = "Something went wrong";
        }
      } else {
        if (username.isEmpty) {
          usernameError = true;
          errorText = "Fill the forms";
        }
        if (password.isEmpty) {
          passwordError = true;
          errorText = "Fill the forms";
        }
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
              child: Text('Log In', style: theme.textTheme.headlineLarge),
            ),
            Container(
              margin: const EdgeInsets.only(left: 25, right: 60),
              alignment: Alignment.centerLeft,
              child: Text('Sync your notes', style: theme.textTheme.titleSmall),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: usernameController,
              hintText: 'Username',
              enabled: !sending,
              error: usernameError,
              multiLine: false,
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
            errorText.isNotEmpty
                ? Center(
                    child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          errorText,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium!
                              .copyWith(color: theme.colorScheme.onError),
                        )),
                  )
                : const SizedBox(height: 30),
            LoginButton(loading: sending, onPressed: login, title: 'Log In'),
            const SizedBox(height: 35),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ForgotPasswordScreen.routeName,
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 25),
                child: Text(
                  "Forgot Password?",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                SignUpScreen.routeName,
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 25),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'No Account? ',
                      ),
                      TextSpan(
                        text: ' Create One',
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
