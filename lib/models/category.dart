import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../helper/db_helpers.dart';
import '../helper/internet_connection.dart';
import 'sync_queue.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = [];
    await getCategory();
    notifyListeners();
    await getCategoryAPI();
    notifyListeners();
  }

  Future<void> deleteCategory(Category category) async {
    _categories.remove(category);
    category.delete();
    notifyListeners();
  }

  Future<void> addCategory(String title) async {
    final category = Category.addCategory(title);
    _categories.add(category);
    notifyListeners();
  }

  Future<void> getCategory() async {
    List categoryList = await DBHelper.getData('category');
    for (Map categoryMap in categoryList) {
      _categories.add(Category.categoryFromMap(categoryMap));
    }
  }

  Future<void> getCategoryAPI() async {
    final token = await AuthToken.accessToken();
    if (await isInternetConnected() && token != null) {
      final response = await http.get(
          Uri.parse('https://notine.liara.run/category/'),
          headers: {'Authorization': "Bearer $token"});
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        for (Map categoryMap in responseData) {
          final category = Category(title: categoryMap['title']);
          if (!_categories.any((element) => element.title == category.title)) {
            category.save();
            _categories.add(category);
          }
        }
      }
    }
  }
}

class Category {
  final String title;

  Category({required this.title});

  void delete() async {
    await DBHelper.deleteWithTitle("note", title);
    SyncQueue.queueSyncRequest(
        action: 'delete',
        tableName: 'category',
        data: {'title': title,}
    );
  }

  static Future<int> createCategoryAPI(String title) async {
    final token = await AuthToken.accessToken();

    final response = await http.post(
        Uri.parse(
          'https://notine.liara.run/category/',
        ),
        body: {'title': title},
        headers: {'Authorization': "Bearer $token"});
    return response.statusCode;
  }

  static Future<int> deleteCategoryAPI(Map data) async {
    final token = await AuthToken.accessToken();
    final response = await http.delete(
        Uri.parse('https://notine.liara.run/category/${data["title"]}/'),
        headers: {'Authorization': "Bearer $token"});
    if (response.statusCode == 204) {
      final category = Category.categoryFromMap(data);
      await DBHelper.deleteWithTitle("category", category.title);
    }
    print(response.body);
    return response.statusCode;
  }

  static Category categoryFromMap(Map map) {
    return Category(title: map['title']);
  }

  void save() async {
    final instanceMap = {
      'title': title,
    };
    DBHelper.insert('category', instanceMap);
  }

  static Category addCategory(String title) {
    final instance = Category(title: title);
    final instanceMap = {
      'title': instance.title,
    };
    DBHelper.insert('category', instanceMap);
    SyncQueue.queueSyncRequest(
        action: 'create', tableName: 'category', data: instanceMap);
    return instance;
  }
}
