import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaselearning/NotePadApp/Src/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  final auth = AuthController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getNotesStream() {
    final userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return firestore
        .collection("notes")
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> uploadNote() async {
    try {
      final userId = auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await firestore.collection("notes").add({
        "title": _titleController.text,
        "description": _descController.text,
        "userId": userId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await firestore.collection("notes").doc(noteId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> updateNote(String noteId) async {
    try {
      await firestore.collection("notes").doc(noteId).update({
        "title": _titleController.text,
        "description": _descController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          "Add New Note",
          style: TextStyle(color: Colors.yellowAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.yellowAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.yellowAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _descController.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              uploadNote().then((_) {
                Navigator.pop(context);
              });
            },
            child: Text(
              "Add",
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateNoteDialog(
      BuildContext context, String noteId, String currentTitle, String currentDescription) {
    _titleController.text = currentTitle;
    _descController.text = currentDescription;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          "Update Note",
          style: TextStyle(color: Colors.yellowAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.yellowAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                labelText: "Description",
                labelStyle: TextStyle(color: Colors.yellowAccent),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.yellowAccent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _descController.clear();
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              updateNote(noteId).then((_) {
                _titleController.clear();
                _descController.clear();
                Navigator.pop(context);
              });
            },
            child: Text(
              "Update",
              style: TextStyle(color: Colors.yellowAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text("Home", style: TextStyle(color: Colors.yellowAccent)),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              auth.logout(context: context);
            },
            icon: Icon(Icons.logout_rounded, color: Colors.yellowAccent),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          backgroundColor: Colors.yellowAccent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.r),
          ),
          onPressed: () => _showAddNoteDialog(context),
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.yellowAccent,
                  backgroundColor: Color(0xFF000000),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading data",
                  style: TextStyle(color: Colors.yellowAccent),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No notes found",
                  style: TextStyle(color: Colors.yellowAccent),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final note = snapshot.data!.docs[index];
                return Card(
                  elevation: 10,
                  color: const Color.fromARGB(255, 255, 245, 157),
                  margin: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    subtitle: Text(
                      note["description"],
                      style: TextStyle(color: Colors.black),
                    ),
                    title: Text(
                      note["title"],
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showUpdateNoteDialog(
                              context,
                              note.id,
                              note["title"],
                              note["description"],
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.black),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            deleteNote(note.id);
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
      ),
    );
  }
}