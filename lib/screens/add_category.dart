import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/appbar.dart';
import '../widgets/custom_text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  static const routeName = '/add-category';

  AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final titleController = TextEditingController();
  bool titleError = false;
  String errorText = '';

  void addCategory (){
    if (titleController.text.isEmpty){
      return setState(() {
        errorText = 'Title cannot be empty';
        titleError = true;
      });
    }
    Navigator.pop(
        context, Category.addCategory(titleController.text));
  }

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
                error: titleError,
              ),
            ]),
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
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                onPressed: addCategory,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 35)),
                child: Text('Save',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: theme.scaffoldBackgroundColor))),
          )
        ]),
      ),
    );
  }
}
