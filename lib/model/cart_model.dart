class CartModel {
  String id;
  dynamic image;
  String name;
  String price;
  String color;
  String size;
  int quantity;

  CartModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.price,
      required this.color,
      required this.size,
      required this.quantity});

  factory CartModel.fromMap(Map<String, dynamic> cartData) {
    return CartModel(
        id: cartData['id'],
        image: cartData['image'],
        name: cartData['name'],
        price: cartData['price'],
        color: cartData['color'],
        size: cartData['size'],
        quantity: int.parse(cartData['itemCount']));
  }

}
