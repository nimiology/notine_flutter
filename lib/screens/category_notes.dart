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

  Future<void> getNotes() async {
    await Future.delayed(const Duration(seconds: 1));
    notes = await category.getCategoryNote();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map?;
    if (routeArgs != null) {
      category = routeArgs['category'];
      if (notes.isEmpty) {
        getNotes();
      }
    }
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getNotes,
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
                              homeScreenSetState: getNotes,
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
