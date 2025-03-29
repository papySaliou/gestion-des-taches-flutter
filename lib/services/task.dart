class Task {
  final int id;
  final String? title;
  final String? content;
  final String? priority;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    this.title,
    this.content,
    this.priority,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sans titre',
      content: json['content'] ?? 'Pas de contenu',
      priority: json['priority'] ?? 'Normale',
      color: json['color'] ?? '#FFFFFF',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
      dueDate: json['dueDate'] != null 
          ? DateTime.parse(json['dueDate']) 
          : null,
    );
  }
}
