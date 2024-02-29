import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../helper/db_helpers.dart';
import '../helper/internet_connection.dart';
import 'category.dart';
import 'note_color_constants.dart';
import 'sync_queue.dart';

class Note {
  int? id;
  int? serverId;
  String title;
  String? content;
  final DateTime created;
  DateTime updated;
  Color color;
  Category category;

  Note({
    this.id,
    this.serverId,
    required this.title,
    this.content,
    required this.created,
    required this.updated,
    required this.color,
    required this.category,
  });

  void delete() async {
    await DBHelper.deleteWithID("note", id!);
    SyncQueue.queueSyncRequest(action: 'delete', tableName: 'note', data: {
      'id': id,
      'server_id': serverId,
      'title': title,
      'content': content,
      'color': colorNames[color],
      'category_title': category.title,
    });
  }

  void save() async {
    final Map<String, Object> instanceMap = {
      'title': title,
      'created': created.millisecondsSinceEpoch,
      'updated': updated.millisecondsSinceEpoch,
      'category_title': category.title,
      'color': colorNames[color] ?? colorNames[getRandomColor()]!,
    };
    if (content != null) {
      instanceMap['content'] = content!;
    }
    if (id != null) {
      instanceMap['id'] = id!;
    }
    if (serverId != null) {
      instanceMap['server_id'] = serverId!;
    }
    id = await DBHelper.insert('note', instanceMap);
    return;
  }

  static Future<int> createNoteAPI(Map data) async {
    final token = await AuthToken.accessToken();
    final response =
        await http.post(Uri.parse('https://notine.liara.run/note/'), body: {
      'title': data['title'],
      'content': data['content'],
      'color': data['color'],
      'category': data['category_title'],
    }, headers: {
      'Authorization': "Bearer $token"
    });
    if (response.statusCode == 201) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final Map<String, Object> instanceMap = {
        'id': data['id'],
        'server_id': responseData['id'],
        'title': data['title'],
        'content': data['content'],
        'color': data['color'],
        'category_title': data['category_title'],
        'created': DateTime.parse(responseData['created'])
            .toLocal()
            .millisecondsSinceEpoch,
        'updated': DateTime.parse(responseData['updated'])
            .toLocal()
            .millisecondsSinceEpoch,
      };
      DBHelper.insert('note', instanceMap);
    }
    return response.statusCode;
  }

  static Future<int> updateNoteAPI(Map data) async {
    final token = await AuthToken.accessToken();
    final response = await http.patch(
        Uri.parse('https://notine.liara.run/note/${data["server_id"]}/'),
        body: {
          'title': data['title'],
          'content': data['content'],
          'color': data['color'],
          'category': data['category_title'],
        },
        headers: {
          'Authorization': "Bearer $token"
        });
    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      final Map<String, Object> instanceMap = {
        'id': data['id'],
        'server_id': responseData['id'],
        'title': data['title'],
        'content': data['content'],
        'color': data['color'],
        'category_title': data['category_title'],
        'created': DateTime.parse(responseData['created'])
            .toLocal()
            .millisecondsSinceEpoch,
        'updated': DateTime.parse(responseData['updated'])
            .toLocal()
            .millisecondsSinceEpoch,
      };
      DBHelper.insert('note', instanceMap);
    }
    return response.statusCode;
  }

  static Future<int> deleteNoteAPI(Map data) async {
    final token = await AuthToken.accessToken();
    final response = await http.delete(
        Uri.parse('https://notine.liara.run/note/${data["server_id"]}/'),
        headers: {'Authorization': "Bearer $token"});
    if (response.statusCode == 204) {
      final note = Note.noteFromMapDB(data);
      await DBHelper.deleteWithID("note", note.id!);
    }
    return response.statusCode;
  }

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

  static Note noteFromMapAPI(Map map) {
    return Note(
      id: map['id'],
      serverId: map['id'],
      title: map['title'],
      content: map['content'],
      created: DateTime.parse(map['created']).toLocal(),
      updated: DateTime.parse(map['updated']).toLocal(),
      color: _getKeyFromValue(map['color']) ?? getRandomColor(),
      category: Category(title: map['category']['title']),
    );
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
    bool createSyncQueue = true,
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
    if (createSyncQueue) {
      if (noteId != id) {
        SyncQueue.queueSyncRequest(
            action: 'create', tableName: 'note', data: instanceMap);
      } else {
        SyncQueue.queueSyncRequest(
            action: 'update', tableName: 'note', data: instanceMap);
      }
    }
    return note;
  }
}

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    _notes = [];
    await getNotes();
    _notes.sort((a, b) => a.updated.compareTo(b.updated));
    notifyListeners();
    await getNotesAPI();
    _notes.sort((a, b) => a.updated.compareTo(b.updated));
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

  Future<void> getNotesAPI() async {
    final token = await AuthToken.accessToken();
    if (await isInternetConnected() && token != null) {
      final response = await http.get(
          Uri.parse('https://notine.liara.run/note/'),
          headers: {'Authorization': "Bearer $token"});
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        for (Map noteMap in responseData) {
          final note = Note.noteFromMapAPI(noteMap);
          if (!_notes.any((element) => element.serverId == note.serverId)) {
            note.save();
            _notes.add(note);
          } else {
            final index = _notes
                .indexWhere((element) => element.serverId == note.serverId);
            final oldNote = _notes[index];
            if (note.updated.isAfter(oldNote.updated)) {
              oldNote.serverId = noteMap['id'];
              oldNote.title = noteMap['title'];
              oldNote.content = noteMap['content'];
              oldNote.color = Note._getKeyFromValue(noteMap['color']) ??
                  Note.getRandomColor();
              oldNote.category = Category(title: noteMap['category']['title']);
              oldNote.updated = DateTime.parse(noteMap['updated']).toLocal();
              oldNote.save();
              _notes[index] = oldNote;
            } else {
              Note.updateNoteAPI({
                'id':oldNote.id,
                'server_id': oldNote.serverId,
                'title': oldNote.title,
                'content': oldNote.content,
                'color': colorNames[oldNote.color],
                'category': oldNote.category.title
              });
            }
          }
        }
      }
    }
  }

  Future<void> getNotes() async {
    List categoryList = await DBHelper.getData('note');
    for (Map categoryMap in categoryList) {
      _notes.add(Note.noteFromMapDB(categoryMap));
    }
  }

  Future<void> deleteNoteBasedOnCategory(Category category) async {
    List<Note> notesCopy = List.from(_notes);

    for (Note note in notesCopy){
      if (note.category.title == category.title){
        await deleteNote(note);
      }
    }
    notifyListeners();
  }
}
