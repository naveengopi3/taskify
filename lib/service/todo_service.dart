import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskify/models/todo_models.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's ID
  String? get userId => _auth.currentUser?.uid; 

  Future<void> addTodo(TodoModel todo) async {
    await _firestore
        .collection('todos')
        .doc(userId)
        .collection('userTodos')
        .add(todo.toMap());
  }

  Stream<List<TodoModel>> getTodos() {
    return _firestore
        .collection('todos')
        .doc(userId)
        .collection('userTodos')
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> updateTodoDetails(TodoModel todo) async {
    await _firestore
        .collection("todos")
        .doc(userId)
        .collection("userTodos")
        .doc(todo.id)
        .update(todo.toMap());
  }

  Future<void> updateTodoStatus(String todId, bool completed) async {
    await _firestore
        .collection("todos")
        .doc(userId)
        .collection('userTodos')
        .doc(todId)
        .update({"completed": completed});
  }

  Future<void> deleteTodo(String todoId) async {
    await _firestore
        .collection("todos")
        .doc(userId)
        .collection("userTodos")
        .doc(todoId)
        .delete();
  }
}
