import 'package:flutter/material.dart';
import 'package:superlabs/Pages/CommunityPage.dart';
import 'package:superlabs/Pages/OffersPage.dart';
import 'package:superlabs/Pages/ProductPage.dart';
import 'package:superlabs/Pages/StorePage.dart';
import 'package:superlabs/Pages/mepage.dart';
import 'package:superlabs/Pages/shop_page.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String _searchQuery = '';  // Store search query

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;  // Update search query when user types
    });
  }

  // Display the selected page content
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return ProductPage(query: _searchQuery);  // Pass search query to ProductPage
      case 1:
        // return const ShopPage();
        return ProductPage(query: _searchQuery);
      case 2:
        // return const OffersPage();
        return ProductPage(query: _searchQuery);
      case 3:
        // return const MePage();
        return ProductPage(query: _searchQuery);
      case 4:
        // return const CommunityPage();
        return ProductPage(query: _searchQuery);
      case 5:
        // return const StorePage();
        return ProductPage(query: _searchQuery);
      default:
        return ProductPage(query: _searchQuery);  // Default query
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onSearch: _onSearch),  // Pass search callback to CustomAppBar
      body: _getPage(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
