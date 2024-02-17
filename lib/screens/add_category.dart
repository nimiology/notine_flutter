import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/custom_text_field.dart';

class AddCategoryScreen extends StatelessWidget {
  static const routeName = '/add-category';
  final titleController = TextEditingController();

  AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const CustomAppBar(
            back: true,
            title: 'Choose Category',
          ),
          Expanded(
            child: ListView(children: [
              CustomTextField(
                controller: titleController,
                hintText: 'Title',
              ),
            ]),
          ),
          Container(
              padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 35)),
                child: Text('Save',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.scaffoldBackgroundColor))),
          )
        ]),
      ),
    );
  }
}
