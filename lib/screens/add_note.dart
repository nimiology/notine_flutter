import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/custom_text_field.dart';

class AddNote extends StatelessWidget {
  static const routeName = '/add-note';
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const CustomAppBar(
          back: true,
          title: 'Add Note',
        ),
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
    ));
  }
}
