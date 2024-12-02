
class Product {
  final String id;
  final String name;
  final String description;
  final num price;
  final int stock;
  final String category;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,  
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', 
      name: json['name'] ?? '', 
      description: json['description'] ?? '', 
      price: json['price'] ?? 0, 
      stock: json['stock'] ?? 0, 
      category: json['category'],
    );
  } 

  Map<String, dynamic> toJson () {
    return {
      '_id' : id,
      'name' : name,
      'description' : description,
      'price' : price,
      'stock' : stock,
      'category' : category,
    };
  }
}