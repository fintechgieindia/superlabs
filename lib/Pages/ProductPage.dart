import 'package:flutter/material.dart';
import 'package:superlabs/Service/productService.dart';

class ProductPage extends StatefulWidget {
  final String query;

  const ProductPage({Key? key, this.query = ''}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreProducts = true;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Initial fetch
    _scrollController.addListener(_onScroll); // Set up the scroll listener
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up the controller
    super.dispose();
  }

  Future<void> _fetchProducts({bool isLoadMore = false}) async {
    if (_isLoadingMore) return; // Prevent multiple calls

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newProducts = await _productService.fetchProducts(
        query: widget.query,
        page: _currentPage,
      );

      setState(() {
        if (isLoadMore) {
          _products.addAll(newProducts);
        } else {
          _products = newProducts;
        }
        _hasMoreProducts = newProducts.isNotEmpty;
        if (_hasMoreProducts) {
          _currentPage++;
        }
      });
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (_hasMoreProducts && !_isLoadingMore) {
        _fetchProducts(isLoadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _products.isEmpty && _isLoadingMore
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _products.isEmpty
                      ? const Center(child: Text("No products found"))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return ProductCard(product: product);
                          },
                        ),
                ),
                if (_isLoadingMore && _products.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
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
    final thumbnailUrl = '$baseUrl$thumbnailPath';
    final title = product['title'] ?? "No title available";
    final price = (product['variants'] != null && product['variants'].isNotEmpty)
        ? product['variants'][0]['currentPrice'] ?? 0
        : 0;
    final rating = product['rating'] ?? 0.0; // Default rating if not provided

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("images/superlabs.png", fit: BoxFit.cover);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text('₹$price', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}