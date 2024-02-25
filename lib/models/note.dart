import 'dart:math';

import 'package:flutter/material.dart';

import '../helper/db_helpers.dart';
import 'category.dart';
import 'note_color_constants.dart';
import 'sync_queue.dart';

class Note {
  final int id;
  int? serverId;
  String title;
  String? content;
  final DateTime created;
  DateTime updated;
  Color color;
  Category category;

  Note({
    required this.id,
    this.serverId,
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

  static Note noteFromMapDB(Map map) {
    return Note(
      id: map['id'],
      serverId: map['server_id'],
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
      items.add(Note.noteFromMapDB(categoryMap));
    }
    return items;
  }

  static Future<Note> addNote({
    int? noteId,
    int? serverId,
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
    if (serverId != null) {
      instanceMap['server_id'] = serverId;
    }
    final id = await DBHelper.insert('note', instanceMap);
    instanceMap['id'] = id;
    final note = Note.noteFromMapDB(instanceMap);
    if (noteId != id) {
      final syncQueue = SyncQueue.queueSyncRequest(
          action: 'create',
          tableName: 'note',
          data: {
            'id': note.id,
            'title': note.title,
            'content': note.content,
            'color': colorNames[note.color],
            'category_title': note.category.title,
          });
    } else {
      final syncQueue = SyncQueue.queueSyncRequest(
          action: 'update',
          tableName: 'note',
          data: {
            'id': note.id,
            'server_id': note.serverId,
            'title': note.title,
            'content': note.content,
            'color': colorNames[note.color],
            'category_title': note.category.title,
          });
    }
    return note;
  }

  void delete() async {
    await DBHelper.delete("note", id);
    final syncQueue = SyncQueue.queueSyncRequest(
        action: 'delete',
        tableName: 'note',
        data: {
          'id': id,
        });
  }
}


class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    _notes = await Note.getNotes();
    notifyListeners();
  }

  Future<void> addNote({
    int? noteId,
    int? serverId,
    required String title,
    String? content,
    required DateTime created,
    required DateTime updated,
    Color? color,
    required Category category,
  }) async {
    final note = await Note.addNote(
      noteId: noteId,
      serverId: serverId,
      title: title,
      content: content,
      created: created,
      updated: updated,
      color: color,
      category: category,
    );
    if (noteId != null) {
      final index = _notes.indexWhere((element) => element.id == noteId);
      _notes[index] = note;
    } else {
      _notes.add(note);
    }
    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    note.delete();
    _notes.remove(note);
    notifyListeners();
  }
}
