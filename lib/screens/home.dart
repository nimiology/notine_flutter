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

  void getNotes() async {
    categories = await Note.getNotesByCategory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        HomeAppbar(
          onTap: () {
            Navigator.pushNamed(context, AddNoteScreen.routeName);
            getNotes();
          },
          screenIcon: const Icon(Icons.add),
        ),
        ...categories.keys.map((key) {
          return CategoryLine(
            category: Category(title: key),
            notes: categories[key]!,
            homeScreenSetState: getNotes,
          );
        }).toList()
      ],
    ));
  }
}
