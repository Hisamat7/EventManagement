class ProductController {
  String name;
  String color;
  int price;

  ProductController({required this.name, required this.color, required this.price});

  Map<String, dynamic> toMap() => {"name": name, "color": color, "price": price};

  factory ProductController.fromMap(Map<String, dynamic> map) => ProductController(name: map["name"], color: map["color"], price: map["price"]);
}