import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../helper/auth_jwt_token_helper.dart';
import '../models/category.dart';
import '../models/note.dart';
import '../models/sync_queue.dart';
import '../widgets/home/category_line.dart';
import '../widgets/home_appbar.dart';
import 'add_note.dart';
import 'login.dart';

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

  Map<String, List<Note>> getNotesByCategory(
      List<Note> noteList, List<Category> categories) {
    Map<String, List<Note>> notesByCategory = {};

    for (Note note in noteList) {
      String categoryTitle = note.category.title;
      final index = categories.indexWhere((element) => element.title == categoryTitle);
      if(index != -1){
        final category = categories[index];
        note.category = category;
      }

      final category = note.category;

      if (!notesByCategory.containsKey(category.title)) {
        notesByCategory[category.title] = [];
      }

      notesByCategory[category.title]!.add(note);
    }

    return notesByCategory;
  }

  Future<void> getNotes() async {
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    Provider.of<SyncQueueProvider>(context, listen: false).processSyncQueue();
    Provider.of<NoteProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    getNotes();

    return Scaffold(
        body: Consumer<NoteProvider>(
          builder: (context, noteProvider, _) {
            final categories = getNotesByCategory(noteProvider.notes,
                Provider.of<CategoryProvider>(context).categories);
            return RefreshIndicator(
              onRefresh: getNotes,
              child: ListView(
                children: [
                  HomeAppbar(
                    onTap: () {},
                    screenIcon: FutureBuilder<bool>(
                        future: AuthToken.isLogin(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!
                                ? GestureDetector(
                                    onTap: () async {
                                      await AuthToken.logout();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Log out',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              color: theme.colorScheme.error),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      await Navigator.pushNamed(
                                          context, LoginScreen.routeName);
                                      setState(() {});
                                    },
                                    child: SvgPicture.asset(
                                      'assets/svgs/user.svg',
                                      width: 20,
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  );
                          }
                          return Container();
                        }),
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
                      category: categories[key]![0].category,
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
            onPressed: () {
              print('asdf');
              Navigator.pushNamed(context, AddNoteScreen.routeName);
            },
            child: Icon(
              Icons.add,
              color: theme.scaffoldBackgroundColor,
            )));
  }
}
