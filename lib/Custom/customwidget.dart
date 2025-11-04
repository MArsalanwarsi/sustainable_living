import 'package:flutter/material.dart';

PreferredSizeWidget buildCustomAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Image.asset('assets/name.png', height: 58, fit: BoxFit.contain),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: IconButton(
          icon: Icon(
            Icons.person_outline_outlined,
            color: Colors.green.shade700,
            size: 26,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile navigation in future')),
            );
          },
        ),
      ),
    ],
  );
}

/// Custom Bottom Navigation Bar
Widget buildCustomBottomBar(context,int currentIndex) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      currentIndex: currentIndex,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
        onTap: (int index) {
        if (index == currentIndex) return;
        // Define your route names according to your app's navigation
        final routes = [
          '/Home',
          '/tracker',
          '/challenges',
          '/products',
          '/form',
        ];
        Navigator.pushReplacementNamed(context, routes[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.energy_savings_leaf_outlined),
          label: 'Tracker',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.flag_outlined),
          label: 'Challanges',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_alt_outlined),
          label: 'Form',
        ),
      ],
    ),
  );
}
