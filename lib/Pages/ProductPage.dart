import 'package:flutter/material.dart';
import 'package:superlabs/Service/productService.dart';

class ProductPage extends StatefulWidget {
  final String query;  // Accept the search query

  const ProductPage({Key? key, this.query = ''}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService _productService = ProductService();
  late Future<List<dynamic>> _productList;

  @override
  void initState() {
    super.initState();
    _productList = _productService.fetchProducts(query: widget.query);  // Fetch products with the query
  }

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _productList = _productService.fetchProducts(query: widget.query); // Fetch new products when query changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "https://eu2.contabostorage.com/eabb361130e04e0c98e8b88a22721601:bb2/";
    final thumbnailPath = product['thumbnail'] ?? "images/superlabs.png";
    final thumbnailUrl = '$baseUrl$thumbnailPath'; // Prepend base URL for remote images
    final title = product['title'] ?? "No title available";
    final price = (product['variants'] != null && product['variants'].isNotEmpty)
        ? product['variants'][0]['currentPrice'] ?? 0
        : 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
    return Image.asset("images/superlabs.png", fit: BoxFit.cover);}
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('₹$price', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
