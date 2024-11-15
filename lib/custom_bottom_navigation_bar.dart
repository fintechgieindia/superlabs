import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xffffeff3),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.store, size: 30), label: 'Shop'),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_offer, size: 30), label: 'Offers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30), label: 'Me'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 30), label: 'Community'),
        BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 30), label: 'Store'),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedFontSize: 9,
      unselectedFontSize: 9,
      selectedItemColor: Color(0xffe49daf), // Active color
      unselectedItemColor: Color(0xff6d6d6d), // Inactive color
    );
  }
}
