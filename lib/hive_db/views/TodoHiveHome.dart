import 'package:firebaselearning/hive_db/model/HiveModel.dart';
import 'package:firebaselearning/hive_db/services/TodoService.dart';
import 'package:flutter/material.dart';

class TodoHiveHome extends StatefulWidget {
  const TodoHiveHome({super.key});

  @override
  State<TodoHiveHome> createState() => _TodoHiveHomeState();
}

class _TodoHiveHomeState extends State<TodoHiveHome> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TodoService todoService = TodoService();
  List<HiveModel> todoList = [];

  // FIX 1: Updated loadData to use setState so the UI rebuilds
  Future<void> loadData() async {
    final todos = await todoService.getAllTodo();
    setState(() {
      todoList = todos;
    });
  }

  @override
  void initState() {
    super.initState();
    // This now correctly loads the data AND updates the screen
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.add),onPressed: () => addTodo(context),),
      appBar: AppBar(
        title: const Text('Hive To-Do List'),
       
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todoList[index];
          return ListTile(
            title: Text(todo.title ?? ""),
            subtitle: Text(todo.description ?? ""),
            trailing: IconButton(
              onPressed: () async {
                // FIX 2: After deleting, we must reload the data to update the UI
                await todoService.deleteTodo(index);
                loadData(); // This will get the new list and call setState
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addTodo(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Todo"),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      validator: (value) => value!.isEmpty ? "Enter name" : null,
                      decoration: const InputDecoration(
                        hintText: "Add a new name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      validator: (value) =>
                          value!.isEmpty ? "Enter description" : null,
                      decoration: const InputDecoration(
                        hintText: "Add a new description",
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final todo = HiveModel(
                            description: descriptionController.text,
                            title: nameController.text);
                        await todoService.addTodo(todo);
                        nameController.clear();
                        descriptionController.clear();
                        Navigator.pop(context);

                        // FIX 3: After adding, we must reload the data to update the UI
                        loadData(); // This will get the new list and call setState
                      }
                    },
                    child: const Text("Save"))
              ],
            ));
  }

  Future<void> editTodo(int index,HiveModel todo) async{
    nameController.text = todo.title ?? "";
    descriptionController.text = todo.description ?? "";
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             TextFormField(style: TextStyle(color: Colors.white),
                   controller: nameController,
                    decoration: InputDecoration(
                  
                     hintStyle: TextStyle(color: Colors.white),
                     filled: true,
                     fillColor: const Color.fromARGB(255, 118, 117, 117),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                        
                      ),
                      hintText: "Add a new name",
                    ),),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(style: TextStyle(color: Colors.white),
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
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel"),),
            TextButton(onPressed: () async{
               todo.title = nameController.text;
              todo.description = descriptionController.text;
              await todoService.updateTodo(index, todo);
              nameController.clear();
              descriptionController.clear();
              Navigator.pop(context);

              // FIX 3: After adding, we must reload the data to update the UI
              loadData(); // This will get the new list and call setState
            }, child: Text("Update"))
          ],
      );
    });
  }
  
}