class Product {
  final String id;
  final String productName;
  final List<String> productUrl;
  final String describe;
  final int price;
  final int quantity;
  final int sold;
  final String type;
  final List<String> color;
  Product({
    required this.id,
    required this.productName,
    required this.productUrl,
    required this.describe,
    required this.price,
    required this.sold,
    required this.quantity,
    required this.type,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productName': productName,
      'productUrl': productUrl,
      'describe': describe,
      'price': price,
      'quantity': quantity,
      'sold': sold,
      'type': type,
      'color': color,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      productName: map['productName'] as String,
      productUrl: List<String>.from((map['productUrl'])),
      describe: map['describe'],
      price: map['price'] as int,
      sold: map['sold'],
      quantity: map['quantity'] as int,
      type: map['type'] as String,
      color: List<String>.from((map['color'])),
    );
  }
}
