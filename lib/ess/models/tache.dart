// class Tache {
//   final String id;
//   final String title;
//   final String content;
//   final String date;
//   final String priority;
//   final String uid; // 🔥 Ajout du champ UID

//   Tache({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.date,
//     required this.priority,
//     required this.uid,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'content': content,
//       'date': date,
//       'priority': priority,
//       'uid': uid, // 🔥 Ajout à la map pour Firestore
//     };
//   }

//   static Tache fromMap(Map<String, dynamic> map) {
//     return Tache(
//       id: map['id'],
//       title: map['title'],
//       content: map['content'],
//       date: map['date'],
//       priority: map['priority'],
//       uid: map['uid'],
//     );
//   }
// }

class Tache {
  final String id;
  final String title;
  final String content;
  final String date;
  final String priority;
  final String uid; // Ensure this field exists

  Tache({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.uid,
  });

  factory Tache.fromMap(String id, Map<String, dynamic> data) {
    return Tache(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] ?? '',
      priority: data['priority'] ?? '',
      uid: data['uid'] ?? '',
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
      'priority': priority,
      'uid': uid,
    };
  }
}