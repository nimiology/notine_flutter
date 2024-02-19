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
    getNotes();
  }

  Future<void> getNotes() async {
    await Future.delayed(const Duration(seconds: 1));
    categories = await Note.getNotesByCategory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: getNotes,
      child: ListView(
        children: [
          HomeAppbar(
            onTap: () async {
              await Navigator.pushNamed(context, AddNoteScreen.routeName);
              getNotes();
            },
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
                        .copyWith(color: Colors.red),
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
    ));
  }
}
