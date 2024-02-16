import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotePreview extends StatelessWidget {
  const NotePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "this is a shit to be as a description, please don't take it so seriously",
              maxLines: 2,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.scaffoldBackgroundColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset(
                'assets/svgs/clock-rotate-left-light.svg',
                width: 20,
                color: theme.scaffoldBackgroundColor,
              ),
              const SizedBox(width: 10,),
              Text('10:00',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.scaffoldBackgroundColor)),
            ],
          )
        ],
      ),
    );
  }
}
