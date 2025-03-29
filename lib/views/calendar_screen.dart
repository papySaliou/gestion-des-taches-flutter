import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:testapi/services/api_service.dart';
import 'package:testapi/services/task.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Task>> _events = {};
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _apiService.fetchTasks();
      setState(() {
        _events = {};
        for (var task in tasks) {
          if (task.dueDate != null) {
            final normalizedDate = DateTime(
              task.dueDate!.year,
              task.dueDate!.month,
              task.dueDate!.day,
            );

            if (_events.containsKey(normalizedDate)) {
              _events[normalizedDate]!.add(task);
            } else {
              _events[normalizedDate] = [task];
            }
          }
        }
      });
    } catch (e) {
      print('Erreur lors du chargement des tâches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier des Tâches')),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2000),
        lastDay: DateTime(2100),
        calendarFormat: CalendarFormat.month,
        eventLoader: (day) => _events[day] ?? [],
        calendarStyle: const CalendarStyle(
          markerDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
