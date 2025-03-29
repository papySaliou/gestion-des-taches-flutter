enum Priority { High, Medium, Low, Elevee, Moyenne, Basse }

class Task {
  String title;
  String content;
  Priority priority;
  String color;
  DateTime? dueDate;

  Task({
    required this.title,
    required this.content,
    required this.priority,
    required this.color,
    this.dueDate,
  });
}
