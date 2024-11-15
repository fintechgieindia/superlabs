// import 'package:flutter/material.dart';
// import 'package:superlabs/Service/productService.dart';
//
// class ProductPage extends StatefulWidget {
//   final String query;
//
//   const ProductPage({Key? key, this.query = ''}) : super(key: key);
//
//   @override
//   _ProductPageState createState() => _ProductPageState();
// }
//
// class _ProductPageState extends State<ProductPage> {
//   final ProductService _productService = ProductService();
//   final ScrollController _scrollController = ScrollController();
//   int _currentPage = 1;
//   bool _isLoadingMore = false;
//   bool _hasMoreProducts = true;
//   List<dynamic> _products = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchProducts(); // Initial fetch
//     _scrollController.addListener(_onScroll); // Set up the scroll listener
//   }
//
//   @override
//   void didUpdateWidget(covariant ProductPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.query != widget.query) {
//       setState(() {
//         _products.clear(); // Clear current products
//         _currentPage = 1; // Reset page number
//         _hasMoreProducts = true; // Reset the load condition
//       });
//       _fetchProducts(); // Fetch new products when query changes
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose(); // Clean up the controller
//     super.dispose();
//   }
//
//   Future<void> _fetchProducts({bool isLoadMore = false}) async {
//     if (_isLoadingMore) return; // Prevent multiple calls
//
//     setState(() {
//       _isLoadingMore = true;
//     });
//
//     try {
//       final newProducts = await _productService.fetchProducts(
//         query: widget.query,
//         page: _currentPage,
//       );
//
//       setState(() {
//         if (isLoadMore) {
//           _products.addAll(newProducts);
//         } else {
//           _products = newProducts;
//         }
//         _hasMoreProducts = newProducts.isNotEmpty;
//         if (_hasMoreProducts) {
//           _currentPage++;
//         }
//       });
//     } catch (e) {
//       print("Error fetching products: $e");
//     } finally {
//       setState(() {
//         _isLoadingMore = false;
//       });
//     }
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
//       if (_hasMoreProducts && !_isLoadingMore) {
//         _fetchProducts(isLoadMore: true);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _products.isEmpty && _isLoadingMore
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Container(
//             margin: EdgeInsets.only(top:5,left: 5,bottom: 5),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.filter_list),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _products.isEmpty
//                 ? const Center(child: Text("No products found"))
//                 : GridView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(8),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.75,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//               ),
//               itemCount: _products.length,
//               itemBuilder: (context, index) {
//                 final product = _products[index];
//                 return ProductCard(product: product);
//               },
//             ),
//           ),
//           if (_isLoadingMore && _products.isNotEmpty)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final dynamic product;
//
//   const ProductCard({Key? key, required this.product}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     const String baseUrl = "https://eu2.contabostorage.com/eabb361130e04e0c98e8b88a22721601:bb2/";
//     final thumbnailPath = product['thumbnail'] ?? "images/superlabs.png";
//     final thumbnailUrl = '$baseUrl$thumbnailPath';
//     final title = product['title'] ?? "No title available";
//     final price = (product['variants'] != null && product['variants'].isNotEmpty)
//         ? product['variants'][0]['currentPrice'] ?? 0
//         : 0;
//     final rating = product['averageRating'] ?? 0.0;
//     final variantscount = product['variants'].length ?? 0;
//
//     // Get screen width to make the card responsive
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600; // Consider screens smaller than 600px as small
//
//     return Card(
//       color: Colors.white,
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: isSmallScreen ? 135 : 150, // Adjust image size based on screen width
//             child: ClipRRect(
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
//               child: Image.network(
//                 thumbnailUrl,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Image.asset("images/superlabs.png", fit: BoxFit.cover);
//                 },
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0), // Adjust padding for small screens
//             child: Text(
//               title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(fontSize: 11), // Adjust font size
//             ),
//           ),
//           // Padding(
//           //   padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//           //   child: Text(
//           //     '$variantscount variants',
//           //     style: TextStyle(fontSize: 8),
//           //   ),
//           // ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0),
//             child: Row(
//               children: [
//                 for (int i = 1; i <= 5; i++)
//                   Icon(
//                     i <= rating.floor()
//                         ? Icons.star
//                         : (i - 1 < rating && rating < i
//                         ? Icons.star_half
//                         : Icons.star_border),
//                     color: Colors.orange,
//                     size: isSmallScreen ? 12 : 16, // Adjust icon size for small screens
//                   ),
//                 const SizedBox(width: 4),
//                 Text(
//                   rating.toStringAsFixed(1),
//                   style: TextStyle(fontSize: 10), // Adjust text size for rating
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0),
//             child: Text(
//               '₹$price',
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 14 : 16, // Adjust font size for price
//               ),
//             ),
//           ),
//           SizedBox(height: 1,)
//         ],
//       ),
//     );
//   }
// }
//
//

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

  String _sortBy = 'Relevance';
  final List<String> _sortOptions = ['Relevance', 'Most Popular', 'Best Selling'];

  String _priceBy = '₹100 to ₹250';
  final List<String> _priceOptions = ['₹100 to ₹250', '₹250 to ₹500', '₹500 to ₹750', '₹750 to ₹1000'];

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Initial fetch
    _scrollController.addListener(_onScroll); // Set up the scroll listener
  }

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        _products.clear();
        _currentPage = 1;
        _hasMoreProducts = true;
      });
      _fetchProducts(); // Fetch new products when query changes
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts({bool isLoadMore = false}) async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newProducts = await _productService.fetchProducts(
        query: widget.query,
        page: _currentPage,
        // Add sort or filter options here if supported by backend
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      height: 35,
      width: 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffffeff3)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          decoration: const InputDecoration.collapsed(hintText: ""),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _products.isEmpty && _isLoadingMore
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Add filter functionality here
                      },
                      icon: const Icon(Icons.filter_list),
                    ),
                  ),
                  const SizedBox(width: 5),
                  _buildDropdown(
                    label: "Sort By",
                    value: _sortBy,
                    options: _sortOptions,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sortBy = value;
                          _products.clear();
                          _currentPage = 1;
                          _fetchProducts();
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 5),
                  _buildDropdown(
                    label: "Price Range",
                    value: _priceBy,
                    options: _priceOptions,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priceBy = value;
                          _products.clear();
                          _currentPage = 1;
                          _fetchProducts();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
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
                return ProductCard(product: product); // Ensure ProductCard exists
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
    final rating = product['averageRating'] ?? 0.0;
    final variantscount = product['variants'].length ?? 0;

    // Get screen width to make the card responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Consider screens smaller than 600px as small

    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: isSmallScreen ? 135 : 150, // Adjust image size based on screen width
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("images/superlabs.png", fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0), // Adjust padding for small screens
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11), // Adjust font size
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0),
                child: Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Icon(
                        i <= rating.floor()
                            ? Icons.star
                            : (i - 1 < rating && rating < i
                            ? Icons.star_half
                            : Icons.star_border),
                        color: Colors.orange,
                        size: isSmallScreen ? 12 : 16, // Adjust icon size for small screens
                      ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(fontSize: 10), // Adjust text size for rating
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0),
                child: Text(
                  '₹$price',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16, // Adjust font size for price
                  ),
                ),
              ),
              SizedBox(height: 1),
            ],
          ),
          // Add a "New" text at the top-left corner
          Positioned(
            left: 5,
            top: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffE69DB0), // Background color
                borderRadius: BorderRadius.circular(12), // Adjust radius as needed
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding for better appearance
              child: Text(
                "New",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ),
          // Add a "Favorite" icon at the top-right corner
          Positioned(
            right: 1,
            top: 1,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Color(0xffE69DB0)),  // Change icon as needed
              onPressed: () {
                // Add your favorite action here
              },
            ),
          ),
        ],
      ),
    );
  }
}
