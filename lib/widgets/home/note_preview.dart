import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/note.dart';
import '../../screens/add_note.dart';

class NotePreview extends StatefulWidget {
  Note note;
  final Function() homeScreenSetState;

  NotePreview({super.key, required this.note, required this.homeScreenSetState});

  @override
  State<NotePreview> createState() => _NotePreviewState();
}

class _NotePreviewState extends State<NotePreview> {
  String timeDifference() {
    final updatedTimeDifference =
        DateTime.now().difference(widget.note.updated);

    if (updatedTimeDifference.inDays >= 30) {
      return 'last month';
    } else if (updatedTimeDifference.inDays > 1) {
      return '${updatedTimeDifference.inDays} days ago';
    } else if (updatedTimeDifference.inDays == 1) {
      return 'yesterday';
    } else if (updatedTimeDifference.inHours >= 1) {
      return '${updatedTimeDifference.inHours} hours ago';
    } else if (updatedTimeDifference.inMinutes > 1) {
      return '${updatedTimeDifference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        final updatedNote = await Navigator.pushNamed(
            context, AddNoteScreen.routeName,
            arguments: {'note': widget.note}) as Note?;
        setState(() {
          if (updatedNote != null) {
            widget.note = updatedNote;
          }
        });
        widget.homeScreenSetState();
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            color: widget.note.color, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.scaffoldBackgroundColor),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.note.content ?? '',
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
                const SizedBox(
                  width: 10,
                ),
                Text(timeDifference(),
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.scaffoldBackgroundColor)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
