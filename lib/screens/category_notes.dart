import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/home/note_preview.dart';

class CategoryNote extends StatelessWidget {
  static const routeName = '/category-notes';
  const CategoryNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(back: true,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                  NotePreview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
