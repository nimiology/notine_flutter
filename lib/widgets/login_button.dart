import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;
  final String title;

  const LoginButton(
      {super.key,
      required this.loading,
      required this.onPressed,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        child: loading
            ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : Text(title),
      ),
    );
  }
}
