

import 'package:firebaselearning/hive_db/model/HiveModel.dart';
import 'package:hive_flutter/adapters.dart';

class TodoService {
  
  Box<HiveModel> ? _todo;

  Future<void> openBox() async{
    _todo = await Hive.openBox<HiveModel>('todo');
  }

  Future<void> closeBox() async{
    await _todo!.close();
  }

  Future<void> addTodo(HiveModel todo) async{
    if (_todo == null) {
      await openBox();
    }
   await _todo!.add(todo);
  }

  Future<void> deleteTodo(int index)async{
    if (_todo == null) {
      await openBox();
    }
    await _todo!.deleteAt(index);
  }

  Future<List<HiveModel>> getAllTodo() async{
    if (_todo == null) {
      await openBox();
    }
    return _todo!.values.toList();
  }

  Future<void> updateTodo(int index,HiveModel todos)async{
    if (_todo == null) {
      await openBox();
    }
    await _todo!.putAt(index, todos);
  }
  
}