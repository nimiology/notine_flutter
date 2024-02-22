import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> getCategoryNote() async {
    final noteList = Provider.of<NoteProvider>(context, listen: false).notes;
    for (Note note in noteList) {
      if (note.category.title == category.title) {
        notes.add(note);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map?;
    if (routeArgs != null) {
      category = routeArgs['category'];
      if (notes.isEmpty) {
        getCategoryNote();
      }
    }
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getCategoryNote,
          child: Column(
            children: [
              CustomAppBar(
                back: true,
                title: category.title,
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: size.width > 600 ? 4 : 2,
                    // Adjust the cross axis count based on screen width
                    childAspectRatio: size.width / (size.height / 1.7),
                    // Adjust aspect ratio for responsiveness
                    children: notes
                        .map((e) => NotePreview(
                              note: e,
                            ))
                        .toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
