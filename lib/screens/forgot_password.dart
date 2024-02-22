import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:notine_flutter/helper/string_extension.dart';

import '../widgets/custom_text_field.dart';
import '../widgets/login_button.dart';
import 'email_sent.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password-screen';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  bool sending = false;
  String errorText = '';
  bool emailError = false;

  void changeSendingState() {
    setState(() {
      sending = !sending;
    });
  }

  Future forgotPassword() async {
    if (!sending) {
      errorText = '';

      changeSendingState();

      final email = emailController.text;

      if (email.isNotEmpty) {
        if(email.isValidEmail()){
          try {
            http.Response response = await http.post(
                Uri.parse('https://notine.liara.run/auth/users/reset_password/'),
                body: {'email': email});
            switch (response.statusCode) {
              case 204:
                {
                  if (context.mounted) {
                    return Navigator.popAndPushNamed(
                        context, EmailSentScreen.routeName);
                  }
                  break;
                }
              case 400:
                {
                  final tokensMap = json.decode(response.body);
                  errorText = tokensMap[0];

                  break;
                }
              case 401:
                {
                  var tokensMap = json.decode(response.body);
                  for (String? key in tokensMap.keys) {
                    errorText += '$key: ${tokensMap[key]}';
                  }
                }
            }

          }
          on SocketException catch (_) {
            errorText = "There is no internet connection";
          } catch (e) {
            errorText = "Something went wrong";
            rethrow;
          }
        } else {
          emailError = true;
          errorText = "Email is not valid.";
        }
      } else if (email.isEmpty) {
        emailError = true;
        errorText = "Fill the forms";
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
          children: [
            Container(
              margin: const EdgeInsets.only(left: 35, top: 40),
              alignment: Alignment.centerLeft,
              child:
                  Text('Forgot Password', style: theme.textTheme.headlineLarge),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, right: 60),
              alignment: Alignment.centerLeft,
              child: Text(
                  "Enter your email and we'll send you a link to get back into your account.",
                  style: theme.textTheme.titleSmall),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: CustomTextField(
                controller: emailController,
                hintText: 'Email',
                svg: 'envelope.svg',
                enabled: !sending,
                error: emailError,
              ),
            ),
            errorText.isNotEmpty
                ? Center(
                    child: Text(
                      errorText,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium!
                          .copyWith(color: theme.colorScheme.onError),
                    ),
                  )
                : const SizedBox(height: 15),
             LoginButton(
                  loading: sending,
                  onPressed: forgotPassword,
                  title: 'Forgot Password'),
          ],
        ),
      ),
    );
  }
}
