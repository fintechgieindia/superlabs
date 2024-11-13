import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = "https://bb2.ashwinsrivastava.com/api/v1/store/product/search";

  Future<List<dynamic>> fetchProducts({required String query, int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$query&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      // Check if 'products' key exists within the nested 'data' map
      if (data['data'] is Map<String, dynamic> && data['data']!['products'] is List<dynamic>) {
        return data['data']!['products'] as List<dynamic>;
      } else {
        return []; // Return an empty list if the data structure is unexpected
      }
    } else {
      throw Exception("Failed to load products");
    }
  }
}
