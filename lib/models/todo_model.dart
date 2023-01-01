// creating POJO class
class todomodel {
  final int? id;
  final int number;
  final String title;
  final String description;
  final bool status;
  final DateTime date;

  //used when creating first time because we will not have id intially.
  todomodel({
    this.id,
    required this.number,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
  });

  // model to map
  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'number': number,
        'status': status ? 1 : 0,
        'date': date.toIso8601String(),
      };

  // map to model
  static todomodel fromMap(Map<String, Object?> mp) => todomodel(
        id: mp['id'] as int?,
        number: mp['number'] as int,
        title: mp['title'] as String,
        description: mp['description'] as String,
        status: mp['status'] == 1,
        date: DateTime.parse(mp['date'] as String),
      );
}
