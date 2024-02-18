import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../widgets/appbar.dart';
import '../widgets/category_tile.dart';
import '../widgets/custom_text_field.dart';
import 'choose_category.dart';
import 'choose_color.dart';

class AddNoteScreen extends StatefulWidget {
  static const routeName = '/add-note';

  AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  String errorText = '';

  bool categoryError = false;
  bool titleError = false;

  Color? color;
  Category? category;

  Note? note;

  void submitNote() async {
    final title = titleController.text;
    final content = descriptionController.text;
    final created = note?.created ?? DateTime.now();
    final updated = DateTime.now();
    final color = this.color;
    final category = this.category;
    if (title.isEmpty) {
      return setState(() {
        titleError = true;
        errorText = 'Title cannot be empty';
      });
    }
    if (category == null) {
      return setState(() {
        categoryError = true;
        errorText = 'Category cannot be empty';
      });
    }
    final updatedNote = Note.addNote(
        noteId: note?.id,
        title: title,
        created: created,
        updated: updated,
        category: category,
        content: content,
        color: color);
    Navigator.of(context).pop(updatedNote);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map?;
    if (routeArgs != null) {
      note = routeArgs['note'];
    }
    if (note != null) {
      titleController.text = note!.title;
      descriptionController.text = note!.content!;
      color ??= note!.color;
      category ??= note!.category;
    }
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            back: true,
            title: note?.updated != null
                ? DateFormat('dd MMMM yyyy - HH:mm').format(note!.updated)
                : 'Add Note',
            svgIcon: note != null ? 'trash.svg' : null,
            svgIconOnTapFunction: note != null
                ? () {
                    note!.delete();
                    Navigator.pop(context);
                  }
                : null,
          ),
          Expanded(
            child: ListView(
              children: [
                CustomTextField(
                  controller: titleController,
                  hintText: 'Title',
                  isTitle: true,
                  error: titleError,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'description',
                ),
              ],
            ),
          ),
          errorText.isNotEmpty
              ? Center(
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: Colors.red),
                      )),
                )
              : const SizedBox(height: 5),
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
                    color: categoryError
                        ? theme.colorScheme.error
                        : theme.scaffoldBackgroundColor,
                    onTap: () async {
                      category = await Navigator.pushNamed(
                          context, ChooseCategoryScreen.routeName) as Category?;
                      if (category != null) {
                        setState(() {});
                      }
                    }),
                ElevatedButton(
                    onPressed: submitNote,
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
