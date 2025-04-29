import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DataBaseController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String title;
  String descrption;

  DataBaseController({required this.title, required this.descrption});

  Map<String, dynamic> toMap() => {"title": title, "descrption": descrption};

  factory DataBaseController.fromMap(Map<String, dynamic> map) =>
      DataBaseController(title: map["title"], descrption: map["descrption"]);

      Future<void> uploadNote({required DataBaseController note}) async {
        await firestore.collection("notes").add(note.toMap());
      }
}
