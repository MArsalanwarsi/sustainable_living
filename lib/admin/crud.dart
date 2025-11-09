import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';

///
/// 🏡 Manage Eco Products Screen (Firebase-ready UI)
///
class ManageEcoProductsScreen extends StatefulWidget {
  const ManageEcoProductsScreen({super.key});

  @override
  State<ManageEcoProductsScreen> createState() =>
      _ManageEcoProductsScreenState();
}

class _ManageEcoProductsScreenState extends State<ManageEcoProductsScreen> {
  // 🎨 Color Palette
  static const Color lightMint = Color(0xFFEDF7F0);
  static const Color mintBackground = Color(0xFFE6F3EA);
  static const Color greenMain = Color(0xFF177A4B);
  static const Color greenDark = Color(0xFF135E3B);

  // 🔍 Search and Sort State
  String searchQuery = '';
  String selectedSort = 'Name (A–Z)';

  // 📦 Temporary Static Product List (replace with Firebase later)
  final List<Map<String, dynamic>> products = [
    {
      'icon': Icons.eco_outlined,
      'name': 'Organic Fertilizer',
      'desc': 'Natural plant food',
    },
    {
      'icon': Icons.water_drop,
      'name': 'Refillable Water Bottle',
      'desc': 'Eco-friendly hydration',
    },
    {
      'icon': Icons.solar_power,
      'name': 'Solar Garden Lights',
      'desc': 'Renewable lighting',
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'name': 'Reusable Produce Bags',
      'desc': 'Zero-waste shopping',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // 🔎 Filtered and Sorted List (safe null handling)
    final filteredProducts =
        products.where((p) {
          final name = (p['name'] ?? '').toString().toLowerCase();
          final desc = (p['desc'] ?? '').toString().toLowerCase();
          return name.contains(searchQuery.toLowerCase()) ||
              desc.contains(searchQuery.toLowerCase());
        }).toList()..sort((a, b) {
          final nameA = (a['name'] ?? '').toString();
          final nameB = (b['name'] ?? '').toString();
          if (selectedSort == 'Name (A–Z)') {
            return nameA.compareTo(nameB);
          } else if (selectedSort == 'Name (Z–A)') {
            return nameB.compareTo(nameA);
          }
          return 0;
        });

    return Scaffold(
      backgroundColor: mintBackground,
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 🏷 Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Eco Products',
                    style: TextStyle(
                      color: greenDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.settings, color: greenDark),
                ],
              ),

              const SizedBox(height: 25),

              // ➕ Add Product Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                      onPressed: () {
                        // TODO: Firebase: Add Product form
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔍 Search + Sort Row
              Row(
                children: [
                  // Search Field
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (query) {
                          setState(() => searchQuery = query);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: greenDark),
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Sort Dropdown
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: const [
                            DropdownMenuItem(
                              value: 'Name (A–Z)',
                              child: Text('Name (A–Z)'),
                            ),
                            DropdownMenuItem(
                              value: 'Name (Z–A)',
                              child: Text('Name (Z–A)'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => selectedSort = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 🧺 Product List (Future: StreamBuilder for Firebase)
              ListView.builder(
                itemCount: filteredProducts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = filteredProducts[index];
                  return ProductCard(
                    icon: item['icon'] ?? Icons.eco_outlined,
                    title: item['name'] ?? 'Unnamed',
                    subtitle: item['desc'] ?? 'No description',
                    color: greenDark,
                    onEdit: () {
                      // TODO: Firebase: Edit Product
                    },
                    onDelete: () {
                      // TODO: Firebase: Delete Product
                    },
                  );
                },
              ),

              SizedBox(height: height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// 📦 Product Card Widget
///
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🌱 Icon Container
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),

          // 📝 Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),

          // ✏️ Edit / 🗑️ Delete Buttons
          Row(
            children: [
              _ActionButton(
                icon: Icons.edit,
                background: Colors.blue.shade100,
                iconColor: Colors.blue.shade700,
                onPressed: onEdit,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.delete,
                background: Colors.red.shade100,
                iconColor: Colors.red.shade700,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///
/// 🔘 Small Reusable Action Button
///
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
