import 'package:firebaselearning/controllers/HomeController.dart';
import 'package:firebaselearning/controllers/ProductController.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  HomeController controller = HomeController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductController>>(
        future: controller.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.color),
                  trailing: Text(product.price.toString()),
              
        );});}}
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        controller.uploadProduct(products: ProductController(name: "mango", color: "red", price: 2000));
      }, child: Icon(Icons.add),),
      appBar: AppBar(
        
        title: Text("Product Screen"),
      ),
    
      
    );
  }
}