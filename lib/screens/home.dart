import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../widgets/home/category_line.dart';
import '../widgets/home_appbar.dart';
import 'add_note.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<Note>> categories = {};

  @override
  void initState() {
    super.initState();
  }

  Map<String, List<Note>> getNotesByCategory(List<Note> noteList) {
    Map<String, List<Note>> notesByCategory = {};

    for (Note note in noteList) {
      String category = note.category.title;

      if (!notesByCategory.containsKey(category)) {
        notesByCategory[category] = [];
      }

      notesByCategory[category]!.add(note);
    }

    return notesByCategory;
  }

  Future<void> getNotes() async {
    await Provider.of<NoteProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    getNotes();

    return Scaffold(
        body: Consumer<NoteProvider>(
          builder: (context, noteProvider, _) {
            final categories = getNotesByCategory(noteProvider.notes);
            return RefreshIndicator(
              onRefresh: getNotes,
              child: ListView(
                children: [
                  HomeAppbar(
                    onTap: () {},
                    screenIcon: const Icon(Icons.add),
                  ),
                  if (categories.isEmpty)
                    Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            'No Notes yet!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: theme.colorScheme.error),
                          )),
                    ),
                  ...categories.keys.map((key) {
                    return CategoryLine(
                      category: Category(title: key),
                      notes: categories[key]!,
                      homeScreenSetState: getNotes,
                    );
                  }).toList()
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: ()  {
              print('asdf');
               Navigator.pushNamed(context, AddNoteScreen.routeName);
            },
            child: Icon(
              Icons.add,
              color: theme.scaffoldBackgroundColor,
            )));
  }
}
