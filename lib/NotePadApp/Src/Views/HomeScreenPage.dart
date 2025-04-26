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

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
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
        title: Text("Add New Note", 
               style: TextStyle(color: Colors.yellowAccent)),
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
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", 
                   style: TextStyle(color: Colors.yellowAccent)),
          ),
          TextButton(
            onPressed: () {
              
              Navigator.pop(context);
            },
            child: Text("Add", 
                   style: TextStyle(color: Colors.yellowAccent)),
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
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Card(
            elevation: 10,
            color: const Color.fromARGB(255, 255, 245, 157),
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: ListTile(
              subtitle: Text("Note description ${index + 1}", 
                     style: TextStyle(color: Colors.black)),
              title: Text("Note ${index + 1}", 
                     style: TextStyle(color: Colors.black)),
              trailing: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
    
      
    );
  }
  

}