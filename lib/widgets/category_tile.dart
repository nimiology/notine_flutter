import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final ThemeData theme;
  final String title;
  final Color color;
  final Function() onTap;

  const CategoryTile({
    super.key,
    required this.theme,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color,
            border: Border.all(color: Colors.black, width: 1.5)),
        child: Text(
          title,
          style: theme.textTheme.labelLarge,
        ),
      ),
    );
  }
}
