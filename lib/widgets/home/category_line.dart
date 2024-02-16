import 'package:flutter/material.dart';

import '../../screens/category_notes.dart';
import 'note_preview.dart';

class CategoryLine extends StatelessWidget {
  const CategoryLine({super.key});

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
                'Art',
                style: theme.textTheme.titleMedium,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, CategoryNote.routeName);
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
          height: 170,
          padding: EdgeInsets.symmetric(horizontal: 5),
          // margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              NotePreview(),
              NotePreview(),
              NotePreview(),
              NotePreview(),
            ],
          ),
        )
      ],
    );
  }
}
