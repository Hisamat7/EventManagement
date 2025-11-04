
import 'package:hive_flutter/adapters.dart';

part 'TodoModelHv.g.dart';
@HiveType(typeId: 0)



class TodoModelHv {
  @HiveField(0)

  late String title;

  @HiveField(1)
  late String description;

  TodoModelHv({required this.title,required this.description});
}

