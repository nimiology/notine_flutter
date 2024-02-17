import 'dart:math';

import 'package:flutter/material.dart';

import '../helper/db_helpers.dart';
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
  DateTime updated;
  Color color;
  Category category;

  Note(
      {required this.id,
      required this.title,
      this.content,
      required this.created,
      required this.updated,
      required this.color,
      required this.category});

  static Color getRandomColor() {
    final randomColor =
        colorNames.keys.toList()[Random().nextInt(colorNames.length)];
    return randomColor;
  }

  static Color? _getKeyFromValue(String value) {
    final entry =
        colorNames.entries.firstWhere((entry) => entry.value == value);
    return entry.key;
  }

  static Note noteFromMap(Map map) {
    print(map);
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created']),
      updated: DateTime.fromMillisecondsSinceEpoch(map['updated']),
      color: _getKeyFromValue(map['color']) ?? getRandomColor(),
      category: Category(title: map['category_title']),
    );
  }

  static Future<List<Note>> getNote() async {
    List<Note> items = [];
    List categoryList = await DBHelper.getData('note');
    for (Map categoryMap in categoryList) {
      items.add(Note.noteFromMap(categoryMap));
    }
    return items;
  }

  static Future<Note> addNote({
    required String title,
    String? content,
    required DateTime created,
    required DateTime updated,
    Color? color,
    required Category category,
  }) async {
    final instanceMap = {
      'title': title,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'category_title': category.title,
    };
    if (color != null) {
      instanceMap['color'] = colorNames[color]!;
    }
    if (content != null) {
      instanceMap['content'] = content;
    }
    final id = await DBHelper.insert('note', instanceMap);
    instanceMap['id'] = id;
    final instance = Note.noteFromMap(instanceMap);
    return instance;
  }
// void delete(String id) async {
//   if (_items.containsKey(id)) {
//     _items.removeWhere((key, value) => key==id);
//     await DBHelper.delete("quit_period", id);
//     notifyListeners();
//   }
// }
}
