

import 'package:hive_flutter/adapters.dart';

part 'HiveModel.g.dart';
@HiveType(typeId: 0)

class HiveModel {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;  

  HiveModel({required this.title,required this.description});
}