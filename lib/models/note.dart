import 'category.dart';

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
