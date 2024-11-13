import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  List<dynamic> searchResults = [];
  static const String baseUrl = "https://bb2.ashwinsrivastava.com/api/v1/store/product/search";

  Future<void> _handleSearch(String query) async {
    setState(() {
      searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl?query=$query'));

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
        });
      } else {
        print('Failed to load search results');
      }
    } catch (error) {
      print('Error fetching search results: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onSearch: _handleSearch),
      body: Center(
        child: searchResults.isEmpty
            ? Text(
                'No Results for "$searchQuery"',
                style: TextStyle(fontSize: 20),
              )
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    title: Text(result['name'] ?? 'Unknown'),
                    subtitle: Text(result['description'] ?? ''),
                  );
                },
              ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;

  const CustomAppBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 25,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('images/superlabs.png', height: 50),
          const SizedBox(width: 8),
          Container(
            width: screenWidth * 0.5,
            child: TextField(
              onSubmitted: (value) {
                onSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 28),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
