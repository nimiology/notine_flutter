import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../models/sync_queue.dart';
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
    notes.clear();
    final noteList =
        Provider.of<NoteProvider>(context, listen: false).notes.reversed;
    for (Note note in noteList) {
      if (note.category.title == category.title) {
        notes.add(note);
      }
    }
  }

  Future<void> getCategoryNoteRefresh() async {
    Provider.of<SyncQueueProvider>(context, listen: false).processSyncQueue();
    await Provider.of<NoteProvider>(context, listen: false).fetchNotes();
    await getCategoryNote();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
          onRefresh: getCategoryNoteRefresh,
          child: Column(
            children: [
              CustomAppBar(
                back: true,
                title: category.title,
                svgIcon: 'trash.svg',
                svgIconOnTapFunction: () async {
                  Provider.of<CategoryProvider>(context, listen: false)
                      .deleteCategory(category);
                  Provider.of<NoteProvider>(context, listen: false)
                      .deleteNoteBasedOnCategory(category);
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: size.width > 600 ? 4 : 2,
                    // Adjust the cross axis count based on screen width
                    childAspectRatio:
                        size.width / (size.height / (isSmallScreen ? 1.7 : 1)),
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
