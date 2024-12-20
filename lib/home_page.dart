import 'dart:developer';

import 'package:flutter/material.dart';
import 'model/todo_model.dart';
import 'services/data/database_serivice.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<TodoModel>>(
        stream: databaseService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No todos available.'));
          }

          final todos = snapshot.data!;
          log("Todos: $todos");

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              log("Todo: ${todo.title}");

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(todo.title ?? "No Title"),
                  subtitle: todo.createdOn != null
                      ? Text("Created On: ${todo.createdOn!.toLocal()}")
                      : null,
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) async {
                      final updatedTodo = todo.copyWith(
                        isDone: value,
                        updatedOn: DateTime.now(),
                      );
                      await databaseService.updateTodo(updatedTodo);
                    },
                  ),
                  onLongPress: () async {
                    await databaseService.deleteTodo(todo.id!);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = TodoModel(
            title: "New Todo",
            createdOn: DateTime.now(),
          );
          await databaseService.addTodo(newTodo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
