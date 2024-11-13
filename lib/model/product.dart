class Product {
  final String imageUrl;
  final String name;
  final double price;
  final double rating;
  bool isWishlisted;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    this.isWishlisted = false,
  });
}
