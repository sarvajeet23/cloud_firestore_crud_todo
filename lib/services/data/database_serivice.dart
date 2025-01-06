import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/todo_model.dart';

const String todoCollectionRef = "todos";

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve all Todos as a stream
  Stream<List<TodoModel>> getTodos() {
    return _firestore.collection(todoCollectionRef).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoModel.fromJson(doc.data(), id: doc.id);
      }).toList();
    });
  } 

  // Add a new Todo to Firestore
  Future<void> addTodo(TodoModel todo) async {
    try {
      await _firestore.collection(todoCollectionRef).add(todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing Todo in Firestore
  Future<void> updateTodo(TodoModel todo) async {
    try {
      if (todo.id == null) {
        throw Exception("Todo ID cannot be null for updating");
      }
      await _firestore
          .collection(todoCollectionRef)
          .doc(todo.id)
          .update(todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Delete a Todo from Firestore
  Future<void> deleteTodo(String id) async {
    try {
      await _firestore.collection(todoCollectionRef).doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
