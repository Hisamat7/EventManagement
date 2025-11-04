import 'package:firebaselearning/hive_db/model/TodoModelHv.dart';
import 'package:firebaselearning/hive_db/services/TodoServiceHive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HiveHome extends StatefulWidget {
  const HiveHome({super.key});

  @override
  State<HiveHome> createState() => _HiveHomeState();
}

class _HiveHomeState extends State<HiveHome> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
   List<TodoModelHv> todoList = [];
  final TodoServiceHive todoService = TodoServiceHive();

    Future<void> loadData() async {
    final todos = await todoService.getAllTodo();
    setState(() {
      todoList = todos;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        addTodoDialog();
      },
      child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Hive To-Do List'),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final data = todoList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 15,
            shadowColor: Colors.black,
            child: ListTile(
              onTap: ()async{
                await editTodoDialog(index, data);
              },
              title: Text(data.title ),
              subtitle: Text(data.description),
              trailing: IconButton(
                onPressed: () async {
                  
                  await todoService.deleteTodo(index);
                  loadData(); 
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void>  addTodoDialog() async{
    await showDialog(context: context, builder: (context)=> AlertDialog(
      content:  Form(
        key: formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               TextFormField(
                validator: (value) => value!.isEmpty ? 'Enter an title' : null,
                style: TextStyle(color: Colors.white),
                     controller: titleController,
                      decoration: InputDecoration(
                    
                       hintStyle: TextStyle(color: Colors.white),
                       filled: true,
                       fillColor: const Color.fromARGB(255, 118, 117, 117),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        hintText: "Add a new title",
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) => value!.isEmpty ? 'Enter an description' : null,
                        style: TextStyle(color: Colors.white),
                     controller: descriptionController,
                      decoration: InputDecoration(
                    
                       hintStyle: TextStyle(color: Colors.white),
                       filled: true,
                       fillColor: const Color.fromARGB(255, 118, 117, 117),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        hintText: "Add a new description",
                      ),)
            ],),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)
            )
          ),
          onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)
            )
          ),
          onPressed: ()async{
            if (formKey.currentState!.validate()) {
              final _todo = TodoModelHv(description: descriptionController.text, title: titleController.text);

              await todoService.addTodo(_todo);
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
              loadData();
            }
          }, child: Text("Add",style: TextStyle(color: Colors.white),))
      ],
    ));
  }

  Future<void>  editTodoDialog(int index,TodoModelHv todo) async{
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    await showDialog(context: context, builder: (context)=> AlertDialog(
      content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             TextFormField(
              
              style: TextStyle(color: Colors.white),
                   controller: titleController,
                    decoration: InputDecoration(
                  
                     hintStyle: TextStyle(color: Colors.white),
                     filled: true,
                     fillColor: const Color.fromARGB(255, 118, 117, 117),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                    
                    ),),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                     
                      style: TextStyle(color: Colors.white),
                   controller: descriptionController,
                    decoration: InputDecoration(
                  
                     hintStyle: TextStyle(color: Colors.white),
                     filled: true,
                     fillColor: const Color.fromARGB(255, 118, 117, 117),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                     
                    ),)
          ],),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)
            )
          ),
          onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel",style: TextStyle(color: Colors.white),)),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)
            )
          ),
          onPressed: ()async{
           todo.title = titleController.text;
              todo.description = descriptionController.text;
              await todoService.updateTodo(index, todo);
              titleController.clear();
              descriptionController.clear();
              Navigator.pop(context);
            loadData();
          }, child: Text("Update",style: TextStyle(color: Colors.white),))
      ],
    ));
  }

}