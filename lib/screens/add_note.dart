import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../widgets/appbar.dart';
import '../widgets/category_tile.dart';
import '../widgets/custom_text_field.dart';
import 'choose_category.dart';
import 'choose_color.dart';

class AddNote extends StatefulWidget {
  static const routeName = '/add-note';

  AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  Color? color;
  Category? category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const CustomAppBar(
            back: true,
            title: 'Add Note',
          ),
          Expanded(
            child: ListView(
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: 'Title',
                  isTitle: true,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'description',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryTile(
                    theme: theme,
                    title: colorNames[color] ?? 'Color',
                    color: color ?? theme.scaffoldBackgroundColor,
                    onTap: () async {
                      color = await Navigator.pushNamed(
                          context, ChooseColorScreen.routeName) as Color?;
                      if (color != null) {
                        setState(() {});
                      }
                    }),
                CategoryTile(
                    theme: theme,
                    title: category?.title ?? 'Category',
                    color: theme.scaffoldBackgroundColor,
                    onTap: () async {
                      category = await Navigator.pushNamed(
                          context, ChooseCategoryScreen.routeName) as Category?;
                      if (category != null) {
                        setState(() {});
                      }
                    }),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 35)),
                    child: Text('Save',
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.scaffoldBackgroundColor)))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
