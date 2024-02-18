import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/note.dart';
import '../../screens/category_notes.dart';
import 'note_preview.dart';

class CategoryLine extends StatelessWidget {
  final List<Note> notes;
  final Category category;
  final Function() homeScreenSetState;

  const CategoryLine(
      {super.key,
      required this.notes,
      required this.category,
      required this.homeScreenSetState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.title,
                style: theme.textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, CategoryNote.routeName,
                      arguments: {'category': category});
                },
                child: Text(
                  'More',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 230,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: notes.reversed
                  .take(3)
                  .map((e) => NotePreview(
                      note: e, homeScreenSetState: homeScreenSetState))
                  .toList()),
        )
      ],
    );
  }
}
