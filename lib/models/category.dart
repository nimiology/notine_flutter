import '../helper/db_helpers.dart';

class Category {
  final String title;

  Category({required this.title});

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

  static Category addQuitPeriod(String title) {
    final instance = Category(title: title);
    DBHelper.insert('category', {
      'title': instance.title,
    });
    return instance;
  }
}
