import 'package:flutter/material.dart';

import 'package:notine_flutter/screens/sync_queue.dart';

class HomeAppbar extends StatelessWidget {
  String appBarName;
  bool chatScreenEnabled;
  VoidCallback onTap;
  Widget screenIcon;

  HomeAppbar(
      {Key? key,
      this.appBarName = 'Notine',
      this.chatScreenEnabled = true,
      required this.onTap,
      required this.screenIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onLongPress: () {
              Navigator.pushNamed(context, SyncQueueScreen.routeName);
            },
            child: Text(
              appBarName,
              style: theme.textTheme.displaySmall,
            ),
          ),
          if (chatScreenEnabled)
            GestureDetector(onTap: onTap, child: screenIcon),
        ],
      ),
    );
  }
}
