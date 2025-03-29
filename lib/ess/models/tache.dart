
class Tache {
  final String id;
  final String title;
  final String content;
  final String date;
  final String priority;
  final String uid; 
  bool status;
  Tache({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.uid,
    this.status = false,
  });

  factory Tache.fromMap(String id, Map<String, dynamic> data) {
    return Tache(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      priority: data['priority'] ?? '',
      uid: data['uid'] ?? '',
      status: data['status'] ?? false,
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'priority': priority,
      'uid': uid,
      'status': status,
    };
  }
}