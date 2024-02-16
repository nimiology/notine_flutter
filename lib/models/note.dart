class Note {
  final int id;
  String title;
  String? content;
  final DateTime created;
  String? color;

  Note(
      {required this.id,
      required this.title,
      this.content,
      required this.created,
      this.color});
}
