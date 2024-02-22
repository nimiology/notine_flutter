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

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    _notes = await Note.getNotes();
    notifyListeners();
  }

  Future<void> addNote({
    int? noteId,
    required String title,
    String? content,
    required DateTime created,
    required DateTime updated,
    Color? color,
    required Category category,
  }) async {
    final note = await Note.addNote(
      noteId: noteId,
      title: title,
      content: content,
      created: created,
      updated: updated,
      color: color,
      category: category,
    );
    _notes.add(note);
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    note.delete();
    _notes.remove(note);
    notifyListeners();
  }


}

class Note {
  final int id;
  String title;
  String? content;
  final DateTime created;
  DateTime updated;
  Color color;
  Category category;

  Note({
    required this.id,
    required this.title,
    this.content,
    required this.created,
    required this.updated,
    required this.color,
    required this.category,
  });

  static Color getRandomColor() {
    final randomColor =
        colorNames.keys.toList()[Random().nextInt(colorNames.length)];
    return randomColor;
  }

  static Color? _getKeyFromValue(String? value) {
    if (value != null) {
      final entry =
          colorNames.entries.firstWhere((entry) => entry.value == value);
      return entry.key;
    }
    return null;
  }

  static Note noteFromMap(Map map) {
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

  static Future<List<Note>> getNotes() async {
    List<Note> items = [];
    List categoryList = await DBHelper.getData('note');
    for (Map categoryMap in categoryList) {
      items.add(Note.noteFromMap(categoryMap));
    }
    return items;
  }

  static Future<Note> addNote({
    int? noteId,
    required String title,
    String? content,
    required DateTime created,
    required DateTime updated,
    Color? color,
    required Category category,
  }) async {
    final Map<String, Object> instanceMap = {
      'title': title,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'category_title': category.title,
      'color': colorNames[color] ?? colorNames[getRandomColor()]!,
    };
    if (content != null) {
      instanceMap['content'] = content;
    }
    if (noteId != null) {
      instanceMap['id'] = noteId;
    }
    final id = await DBHelper.insert('note', instanceMap);
    instanceMap['id'] = id;
    final instance = Note.noteFromMap(instanceMap);
    return instance;
  }

  void delete() async {
    await DBHelper.delete("note", id);
  }
}
