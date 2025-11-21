import 'package:flutter/material.dart';

PreferredSizeWidget buildAdminCustomAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
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
            Navigator.pushNamed(context, '/AdminProfile');
          },
        ),
      ),
    ],
  );
}

/// Custom Bottom Navigation Bar
Widget buildAdminCustomBottomBar(BuildContext context, int currentIndex) {
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
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      currentIndex: (currentIndex >= 0 && currentIndex < 6) ? currentIndex : -1,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      onTap: (int index) {
        if (index == currentIndex) return;
        // Define your route names according to your app's navigation
        final routes = [
          '/AdminDashboard',
          '/AdminChallenges',
          '/AdminProducts',
          '/AdminFeed',
          '/AdminTip',
          '/UserManagement',
        ];
        Navigator.pushReplacementNamed(context, routes[index]);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Dashboard',
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
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          label: 'Tip',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Users',
        ),
      ],
    ),
  );
}
