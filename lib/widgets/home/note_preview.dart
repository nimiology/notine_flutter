import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/note.dart';
import '../../screens/add_note.dart';

class NotePreview extends StatefulWidget {
  Note note;

  NotePreview({super.key, required this.note});

  @override
  State<NotePreview> createState() => _NotePreviewState();
}

class _NotePreviewState extends State<NotePreview> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      // Call setState to trigger a rebuild every minute
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String timeDifference() {
    final updatedTimeDifference = DateTime.now().difference(widget.note.updated);

    if (updatedTimeDifference.inDays >= 30) {
      return 'last month';
    } else if (updatedTimeDifference.inDays >= 1) {
      return '${updatedTimeDifference.inDays} ${updatedTimeDifference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (updatedTimeDifference.inHours >= 1) {
      return '${updatedTimeDifference.inHours} ${updatedTimeDifference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (updatedTimeDifference.inMinutes >= 1) {
      return '${updatedTimeDifference.inMinutes} ${updatedTimeDifference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AddNoteScreen.routeName,
              arguments: {'note': widget.note},
            );
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
            width: maxWidth < 400 ? maxWidth : 200,
            decoration: BoxDecoration(
              color: widget.note.color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.note.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.note.content ?? '',
                        maxLines: 4,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.scaffoldBackgroundColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/clock-rotate-left-light.svg',
                      width: 20,
                      color: theme.scaffoldBackgroundColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      timeDifference(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
