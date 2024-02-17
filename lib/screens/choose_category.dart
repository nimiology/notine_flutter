import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/appbar.dart';
import '../widgets/category_tile.dart';
import 'add_category.dart';

class ChooseCategoryScreen extends StatefulWidget {
  static const routeName = '/choose-category';

  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  void getCategories() async {
    categories = await Category.getCategory();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              back: true,
              title: 'Choose Category',
              svgIcon: 'plus-solid.svg',
              svgIconOnTapFunction: () async {
                final category = await Navigator.pushNamed(
                    context, AddCategoryScreen.routeName) as Category?;
                if (category != null) {
                  getCategories();
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                      spacing: 5,
                      runSpacing: 15,
                      alignment: WrapAlignment.start,
                      children: categories
                          .map((element) => CategoryTile(
                              theme: theme,
                              title: element.title,
                              color: theme.scaffoldBackgroundColor,
                              onTap: () {
                                Navigator.pop(
                                  context,
                                  element,
                                );
                              }))
                          .toList()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
