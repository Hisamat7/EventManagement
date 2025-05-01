import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaselearning/FirebaseStudy/controllers/ProductController.dart';
import 'package:flutter/material.dart';

class HomeController {
  final dbstore = FirebaseFirestore.instance;
  Future<void> uploadProduct({ProductController? products}) async {
    await dbstore
        .collection("products")
        .doc()
        .set(products!.toMap())
        .then((value) => debugPrint("Product uploaded"))
        .onError((error, stackTrace) => debugPrint("Product not uploaded"));
  }

  Future<List<ProductController>> getProducts() async {
    
    final products = await dbstore.collection("products").get();
    return products.docs.map((e) => ProductController.fromMap(e.data())).toList();
  }
}
