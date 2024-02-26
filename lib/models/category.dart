import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../helper/auth_jwt_token_helper.dart';
import '../helper/db_helpers.dart';
import 'sync_queue.dart';

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

  static Future<int> createCategoryAPI(String title)async{
    final token = await AuthToken.accessToken();

    final response = await http.post(
        Uri.parse(
          'https://notine.liara.run/category/',
        ),
        body: {'title':title},
        headers: {'Authorization': "Bearer $token"});
    return response.statusCode;
  }

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
    final instanceMap = {
      'title': instance.title,
    };
    DBHelper.insert('category', instanceMap);
    final syncQueue = SyncQueue.queueSyncRequest(
        action: 'create',
        tableName: 'category',
        data: instanceMap);
    return instance;
  }
}
