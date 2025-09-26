class Product {
  final String name;
  final double price;
  final String image;     // local image from assets/images
  final String category;  // e.g., "new", "chair", "sofa"
  bool isFavorite;        // can be toggled in UI
  final String unityModel; // prefab name for AR

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.isFavorite = false,
    required this.unityModel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],       // e.g. "assets/images/coral_desk.png"
      category: json['category'] ?? "general",
      isFavorite: json['isFavorite'] ?? false,
      unityModel: json['unityModel'], // prefab name from Unity
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "image": image,
      "category": category,
      "isFavorite": isFavorite,
      "unityModel": unityModel,
    };
  }
}
