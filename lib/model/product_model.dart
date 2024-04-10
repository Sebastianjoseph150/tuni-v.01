class Product {
  final String id;
  final String name;
  final String gender;
  final String category;
  final String brand;
  final String price;
  final dynamic imageUrl;
  final String time;
  final dynamic size;
  final String quantity;
  final String color;

  Product(
      {required this.id,
      required this.name,
      required this.gender,
      required this.category,
      required this.brand,
      required this.price,
      required this.imageUrl,
      required this.time,
      required this.size,
      required this.quantity,
      required this.color});

  factory Product.fromMap(Map<String, dynamic> productData) {
    return Product(
      id: productData['id'],
      name: productData['name'],
      gender: productData['gender'],
      category: productData['category'],
      brand: productData['brand'],
      price: productData['price'],
      imageUrl: productData['imageUrl'] ?? '',
      time: productData['time'],
      size: productData['size'],
      quantity: productData['Quantity'] ?? 0,
      color: productData['color'],
    );
  }

}
