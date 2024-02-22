import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../widgets/appbar.dart';

class EmailSentScreen extends StatelessWidget {
  static const routeName = '/email-sent-screen';

  const EmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: [
              const CustomAppBar(
                back: true,
                title: "Email Sent",
              ),
              const SizedBox(height: 50,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/envelope.svg',
                    width: 40,
                    height: 40,
                    color: theme.colorScheme.onBackground,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text('The link has sent to your email.',
                        style: theme.textTheme.titleMedium),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
