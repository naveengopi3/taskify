import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoModel {
  String id;
  String todo;
  DateTime date;
  TimeOfDay time;
  bool completed;

  TodoModel({
    required this.id,
    required this.todo,
    required this.date,
    required this.time,
    this.completed = false,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    TimeOfDay parsedTime = TimeOfDay(
      hour: (map['time'] as Timestamp).toDate().hour,
      minute: (map['time'] as Timestamp).toDate().minute,
    );
    return TodoModel(
      id: id,
      todo: map['todo'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      time: parsedTime,
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    DateTime dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return {
      'todo': todo,
      'date': date,
      'time': dateTime,
      'completed': completed,
    };
  }
}
