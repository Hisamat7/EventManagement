import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselearning/TodoApp/src/Controller/AuthControllerTodo.dart';
import 'package:firebaselearning/TodoApp/src/widgets/TextFieldWidgetTodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTodo extends StatefulWidget {
  const HomeTodo({super.key});

  @override
  State<HomeTodo> createState() => _HomeTodoState();
}

class _HomeTodoState extends State<HomeTodo> {
  final dbstore = FirebaseFirestore.instance;
  final _authController = AuthControllerTodo();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 20),
        child: FloatingActionButton(
          onPressed: () => _showAddTodoDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.orangeAccent,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Home Todo",
          style: TextStyle(color: Colors.orangeAccent),
        ),
        actions: [
          IconButton(
            onPressed:
                () async => await _authController.logout(context: context),
            icon: const Icon(Icons.logout_rounded, color: Colors.orangeAccent),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getTodosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No todos found",
                style: TextStyle(color: Colors.orangeAccent),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: ListTile(
                  title: Text(
                    todo["title"],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    todo["description"],
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () => _showEditTodoDialog(context, todo),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () async {
                          await deleteTodo(todo.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              "Add New Note",
              style: TextStyle(color: Colors.orangeAccent),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidgetTodo(
                  controller: _titleController,
                  hintText: "Title",
                  validator:
                      (value) => value!.isEmpty ? 'Enter an title' : null,
                  label: "Title",
                ),
                SizedBox(height: 16.h),
                TextFieldWidgetTodo(
                  controller: _descriptionController,
                  hintText: "Description",
                  validator:
                      (value) => value!.isEmpty ? 'Enter an description' : null,
                  label: "Description",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _titleController.clear();
                  _descriptionController.clear();
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await addTodo();
                },
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
    );
  }
// Add todo
  Future<void> addTodo() async {
    try {
      await dbstore.collection("todos").add({
        "title": _titleController.text,
        "description": _descriptionController.text,
        "createdAt": FieldValue.serverTimestamp(),
        "userId": _authController.currentUser?.uid,
      });
      _titleController.clear();
      _descriptionController.clear();
      Navigator.pop(context);
    } catch (e) {
      SnackBar(content: Text("Error: ${e.toString()}"));
    }
  }

  Stream<QuerySnapshot> getTodosStream() {
    final userId = _authController.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return dbstore
        .collection("todos")
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
// Delete todo
  Future<void> deleteTodo(String todoId) async {
    try {
      await dbstore.collection("todos").doc(todoId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('todo deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  // Edit todo
  Future<void> _showEditTodoDialog(
    BuildContext context,
    DocumentSnapshot todo,
  ) async {
    final editTitleController = TextEditingController(text: todo['title']);
    final editDescriptionController = TextEditingController( text: todo['description'],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: Text(
              "Edit Todo",
              style: TextStyle(color: Colors.orangeAccent),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFieldWidgetTodo(
                  controller: editTitleController,
                  hintText: "Title",
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                  label: "Title",
                ),
                SizedBox(height: 16.h),
                TextFieldWidgetTodo(
                  controller: editDescriptionController,
                  hintText: "Description",
                  validator:
                      (value) => value!.isEmpty ? 'Enter a description' : null,
                  label: "Description",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (editTitleController.text.isNotEmpty &&
                      editDescriptionController.text.isNotEmpty) {
                    await updateTodo(
                      todo.id,
                      editTitleController.text,
                      editDescriptionController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
    );
  }

  // Add this update method
  Future<void> updateTodo(
    String todoId,
    String newTitle,
    String newDescription,
  ) async {
    try {
      await dbstore.collection("todos").doc(todoId).update({
        "title": newTitle,
        "description": newDescription,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating todo: ${e.toString()}')),
      );
    }
  }

}
