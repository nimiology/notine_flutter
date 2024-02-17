import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/category_tile.dart';
import '../widgets/custom_text_field.dart';
import 'choose_category.dart';

class AddNote extends StatelessWidget {
  static const routeName = '/add-note';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  AddNote({super.key});

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
                    title: 'Color',
                    color: theme.scaffoldBackgroundColor,
                    onTap: () async {
                      Navigator.pushNamed(
                          context, ChooseCategoryScreen.routeName);
                    }),
                CategoryTile(
                    theme: theme,
                    title: 'Category',
                    color: theme.scaffoldBackgroundColor,
                    onTap: () async {
                      Navigator.pushNamed(
                          context, ChooseCategoryScreen.routeName);
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
