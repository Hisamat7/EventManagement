import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaselearning/TodoSample/src/controllers/AuthTs.dart';
import 'package:firebaselearning/TodoSample/src/widgets/TextFieldTs.dart';
import 'package:flutter/material.dart';

class HomePageTs extends StatefulWidget {
  const HomePageTs({super.key});

  @override
  State<HomePageTs> createState() => _HomePageTsState();
}

class _HomePageTsState extends State<HomePageTs> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final auth = AuthTs();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20,bottom: 20),
        child: FloatingActionButton(
          elevation: 8,
          
          onPressed: ()async{
          await  addData();
          },child: Icon(Icons.add),),
      ),
      appBar: AppBar(title: Text("Home Page"),actions: [
        IconButton(onPressed: (){
          auth.logout(context: context);
        }, icon: Icon(Icons.logout_rounded))
      ],),
     body: StreamBuilder(stream: getTodosStream(), builder: (context, snapshot) {
       if(snapshot.connectionState == ConnectionState.waiting){
         return const Center(child: CircularProgressIndicator(),);
       }else if(snapshot.hasError){
         return const Center(child: Text("Error"),);
       }else{
         final todos = snapshot.data!.docs;
         return ListView.builder(
           itemCount: todos.length,
           itemBuilder: (context, index){
             final todo = todos[index];
             return Padding(
               padding: const EdgeInsets.only(top: 30),
               child: Card(
                 elevation: 8,
                 margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                 child: ListTile(
                   title: Text(todo["title"]),
                   subtitle: Text(todo["description"]),
                 ),
               ),
             );
           },
         );
       }
     }), 
    );
  }
  addData()async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 238, 255, 239),
        content: SizedBox(
          height: 210,
          child: Column(
            children: [
              TextFieldTs(text: "Title", controller: titleController,hintText: "enter the title",validator: (p0) => p0!.isEmpty ? 'please Enter an title' : null,),
              const SizedBox(height: 20,),
              TextFieldTs(height: 4,
                text: "Description", controller: descriptionController,hintText: "Enter the description",validator: (p0) => p0!.isEmpty ? 'please Enter an description' : null,)
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel"),style: TextButton.styleFrom(foregroundColor: Colors.red),),
          TextButton(onPressed: ()async{
          await  createData();
          }, child: Text("Save"),style: TextButton.styleFrom(foregroundColor: Colors.green),)
        ],
      );
    });
  }
  //
  Future<void> createData() async{
try {
  await _firestore.collection("todosTs").add({
    "createdAt": FieldValue.serverTimestamp(),
    "userId": auth.currentUser?.uid,
    "title": titleController.text,
    "description": descriptionController.text
  });
  SnackBar(content: Text("Todo added successfully!"));
  titleController.clear();
  descriptionController.clear();
  Navigator.pop(context);
  
} catch (e) {
  SnackBar(content: Text("Error: ${e.toString()}"));
}
  }

  Stream<QuerySnapshot> getTodosStream() => _firestore.collection("todosTs").where("userId",isEqualTo: auth.currentUser?.uid).snapshots();

  Future<void> deleteData() async{
    await _firestore.collection("todosTs").doc().delete();
  }
}