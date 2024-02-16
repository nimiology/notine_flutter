import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppbar extends StatelessWidget {
  String appBarName;
  bool chatScreenEnabled;
  VoidCallback onTap;
  Widget screenIcon;

  HomeAppbar({
    Key? key,
    this.appBarName = 'Notine',
    this.chatScreenEnabled = true,
    required this.onTap,
    required this.screenIcon

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            appBarName,
            style: theme.textTheme.headlineMedium,
          ),
          if (chatScreenEnabled)
            GestureDetector(
                onTap: onTap,
                child: screenIcon
            ),
        ],
      ),
    );
  }
}