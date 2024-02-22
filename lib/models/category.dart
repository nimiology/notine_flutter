import 'package:flutter/material.dart';
import '../helper/db_helpers.dart';
import 'note.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = await Category.getCategory();
    notifyListeners();
  }

  Future<void> addCategory(String title) async {
    final category = Category.addCategory(title);
    _categories.add(category);
    notifyListeners();
  }
}

class Category {
  final String title;

  Category({required this.title});

  static Category categoryFromMap(Map map) {
    return Category(title: map['title']);
  }

  static Future<List<Category>> getCategory() async {
    List<Category> _items = [];
    List categoryList = await DBHelper.getData('category');
    for (Map categoryMap in categoryList) {
      _items.add(Category.categoryFromMap(categoryMap));
    }
    return _items;
  }

  static Category addCategory(String title) {
    final instance = Category(title: title);
    DBHelper.insert('category', {
      'title': instance.title,
    });
    return instance;
  }
}
