import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../widgets/appbar.dart';
import '../widgets/home/note_preview.dart';

class CategoryNote extends StatefulWidget {
  static const routeName = '/category-notes';

  CategoryNote({super.key});

  @override
  State<CategoryNote> createState() => _CategoryNoteState();
}

class _CategoryNoteState extends State<CategoryNote> {
  late Category category;
  List<Note> notes = [];


  void getNotes() async {
    notes = await category.getCategoryNote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map?;
    if (routeArgs != null) {
      category = routeArgs['category'];
      if (notes.isEmpty){
        getNotes();
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              back: true,
              title: category.title,
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: notes
                      .map((e) => NotePreview(
                            note: e,
                    homeScreenSetState: getNotes,
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
