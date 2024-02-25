import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/note_color_constants.dart';
import '../widgets/appbar.dart';
import '../widgets/category_tile.dart';




class ChooseColorScreen extends StatelessWidget {
  static const routeName = '/choose-color';

  const ChooseColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(
              back: true,
              title: 'Choose Color',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 15,
                    alignment: WrapAlignment.start,
                    children: colorNames.keys.map((color) {
                      return CategoryTile(
                        theme: theme,
                        title: colorNames[color] as String,
                        color: color,
                        onTap: () {
                          Navigator.pop(
                            context,
                            color,
                          );
                        },
                      );
                    }).toList(),                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
