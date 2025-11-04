
import 'package:firebaselearning/hive_db/model/TodoModelHv.dart';
import 'package:hive_flutter/adapters.dart';

class TodoServiceHive {
  
  Box<TodoModelHv> ?todoBox;

  Future<void>  openBox() async{
    todoBox = await Hive.openBox<TodoModelHv>('todo');
  }

  Future<void> closeBox() async{
    await Hive.close();
  }

  Future<void> addTodo(TodoModelHv todo) async{
    if (todoBox == null) {
      await openBox();
    }
    await todoBox!.add(todo);
  }

  Future<List<TodoModelHv>> getAllTodo() async{
    if (todoBox == null) {
      await openBox();
    }
    return todoBox!.values.toList();
  }

  Future<void> deleteTodo(int index) async{
    if (todoBox == null) {
      await openBox();
    }
    await todoBox!.deleteAt(index);
  }

  Future<void> updateTodo(int index,TodoModelHv updateValue)async{
    if (todoBox == null) {
      await openBox();
    }

    await todoBox!.putAt(index, updateValue);
  }
}