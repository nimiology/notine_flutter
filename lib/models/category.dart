import '../helper/db_helpers.dart';
import 'note.dart';

class Category {
  final String title;

  Category({required this.title});

  Future<List<Note>> getCategoryNote() async {
    List<Note> notes = [];

    final noteList = await Note.getNotes();
    for (Note note in noteList) {
      String category = note.category.title;
      if (category == title) {
        notes.add(note);
      }
    }

    return notes;
  }

  static categoryFromMap(Map map) {
    return Category(title: map['title']);
  }

  static Future<List<Category>> getCategory() async {
    List<Category> _itemss = [];
    List categoryList = await DBHelper.getData('category');
    for (Map categoryMap in categoryList) {
      _itemss.add(Category.categoryFromMap(categoryMap));
    }
    return _itemss;
  }

  static Category addCategory(String title) {
    final instance = Category(title: title);
    DBHelper.insert('category', {
      'title': instance.title,
    });
    return instance;
  }
}
