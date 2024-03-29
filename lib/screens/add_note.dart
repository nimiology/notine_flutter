import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/note.dart';
import '../models/note_color_constants.dart';
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
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  String errorText = '';

  bool categoryError = false;
  bool titleError = false;

  bool saving = false;

  Color? color;
  Category? category;

  Note? note;

  void submitNote() async {
    if (saving) {
      return;
    }

    // first check if anything has not changed
    if (titleController.text == note?.title &&
        descriptionController.text == note?.content &&
        this.color == note?.color &&
        this.category?.title == note?.category.title) {
      return Navigator.of(context).pop();
    }
    saving = true;
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
        saving = false;
      });
    }

    if (category == null) {
      return setState(() {
        categoryError = true;
        errorText = 'Category cannot be empty';
        saving = false;
      });
    }

    final updatedNote = Provider.of<NoteProvider>(context, listen: false)
        .addNote(
            noteId: note?.id,
            serverId: note?.serverId,
            title: title,
            created: created,
            updated: updated,
            category: category,
            content: content,
            color: color);

    Navigator.of(context).pop(updatedNote);
    saving = false;
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
                      Provider.of<NoteProvider>(context, listen: false)
                          .deleteNote(note!);
                      Navigator.pop(context);
                    }
                  : null,
              backFunction: () {
                if (note != null) {
                  submitNote();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Title',
                    isTitle: true,
                    error: titleError,
                    // onChanged: (_) => setState(() {
                    //   titleError = false;
                    //   errorText = '';
                    // }),
                    focusNode: titleFocusNode,
                  ),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    focusNode: descriptionFocusNode,
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
                            .copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  )
                : const SizedBox(height: 5),
            Container(
              height: 80,
              padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryTile(
                    theme: theme,
                    title: colorNames[color] ?? 'Color',
                    color: color ?? theme.scaffoldBackgroundColor,
                    onTap: () async {
                      final updatedColor = await Navigator.pushNamed(
                          context, ChooseColorScreen.routeName) as Color?;
                      if (updatedColor != null) {
                        setState(() {
                          color = updatedColor;
                        });
                      }
                    },
                  ),
                  CategoryTile(
                    theme: theme,
                    title: category?.title ?? 'Category',
                    color: categoryError
                        ? theme.colorScheme.error
                        : theme.scaffoldBackgroundColor,
                    onTap: () async {
                      final updateCategory = await Navigator.pushNamed(
                          context, ChooseCategoryScreen.routeName) as Category?;
                      if (updateCategory != null) {
                        setState(() {
                          category = updateCategory;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => submitNote(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 35,
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: theme.scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
