import 'package:flutter/material.dart';

import 'category.dart';

final Map<Color, String> colorNames = {
  Colors.red: 'Red',
  Colors.blue: 'Blue',
  Colors.green: 'Green',
  Colors.yellow: 'Yellow',
  Colors.orange: 'Orange',
  Colors.purple: 'Purple',
  Colors.teal: 'Teal',
  Colors.pink: 'Pink',
  Colors.cyan: 'Cyan',
  Colors.amber: 'Amber',
  Colors.indigo: 'Indigo',
  Colors.lime: 'Lime',
  Colors.brown: 'Brown',
  Colors.deepPurple: 'Deep Purple',
  Colors.lightBlue: 'Light Blue',
  Colors.lightGreen: 'Light Green',
  Colors.deepOrange: 'Deep Orange',
  Colors.grey: 'Grey',
  Colors.blueGrey: 'Blue Grey',
  Colors.white: 'White',
  Colors.deepOrangeAccent: 'Deep Orange Accent',
  Colors.deepPurpleAccent: 'Deep Purple Accent',
  Colors.greenAccent: 'Green Accent',
  Colors.amberAccent: 'Amber Accent',
  Colors.blueAccent: 'Blue Accent',
  Colors.cyanAccent: 'Cyan Accent',
  Colors.orangeAccent: 'Orange Accent',
  Colors.indigoAccent: 'Indigo Accent',
  Colors.pinkAccent: 'Pink Accent',
  Colors.redAccent: 'Red Accent',
};

class Note {
  final int id;
  String title;
  String? content;
  final DateTime created;
  final DateTime updated;
  String? color;
  Category? categories;

  Note(
      {required this.id,
      required this.title,
      this.content,
      required this.created,
      required this.updated,
      this.color,
      this.categories});
}
