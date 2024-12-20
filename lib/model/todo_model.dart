import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String? title;
  bool isDone;
  DateTime? createdOn;
  DateTime? updatedOn;

  TodoModel({
    this.id,
    this.title,
    this.isDone = false,
    this.createdOn,
    this.updatedOn,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  // Factory constructor to create a TodoModel from JSON
  factory TodoModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return TodoModel(
      id: id,
      title: json['title'],
      isDone: json['isDone'] ?? false,
      createdOn: (json['createdOn'] as Timestamp?)?.toDate(),
      updatedOn: (json['updatedOn'] as Timestamp?)?.toDate(),
    );
  }

  // Method to convert a TodoModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'createdOn': createdOn != null ? Timestamp.fromDate(createdOn!) : null,
      'updatedOn': updatedOn != null ? Timestamp.fromDate(updatedOn!) : null,
    };
  }

  // CopyWith method for creating modified copies of TodoModel
  TodoModel copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdOn,
    DateTime? updatedOn,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }
}
