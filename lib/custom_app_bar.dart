import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String) onSearch;  // Callback to handle the search query

  const CustomAppBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        elevation: 25,
        backgroundColor: Color(0xFFD9407D), // Correct hex color format
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the content vertically
          children: [
            Row(
              mainAxisSize: MainAxisSize.min, // Ensures Row takes minimum width
              children: [
                Image.asset('images/superlabs.png', height: 50),
                const SizedBox(width: 8),
                Container(
                  width: 200, // Set a fixed width for the search field
                  child: TextField(
                    onSubmitted: (value) {
                      onSearch(value);  // Pass the search value to the parent widget
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.favorite_border, size: 28),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, size: 28),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
