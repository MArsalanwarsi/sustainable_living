import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

// 🌿 Product Model
class Product {
  final String id;
  final String name;
  final double price;
  final double greenPoints;
  final double co2Saved;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.greenPoints,
    required this.co2Saved,
    required this.imageUrl,
    required this.description,
  });
}

// 🌿 Mock Product Service
class ProductService {
  // static List<Product> getMockProducts() async {
  static Future<List<Product>> getMockProducts() async {
    List<Product> productList = [];
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Products')
          .get();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        productList.add(
          Product(
            id: doc.id,
            name: data['name'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            greenPoints: (data['greenPoints'] ?? 0).toDouble(),
            co2Saved: (data['co2'] ?? 0).toDouble(),
            imageUrl: data['image'] ?? '',
            description: data['description'] ?? '',
          ),
        );
      }
    } catch (e) {
      print("Error $e");
    }
    return productList;
  }
}

// 🌿 Wishlist Service
class WishlistService {
  static Set<String> wishlist = {};

  static void addToWishlist(String productId) {
    wishlist.add(productId);
  }

  static void removeFromWishlist(String productId) {
    wishlist.remove(productId);
  }

  static bool isInWishlist(String productId) {
    return wishlist.contains(productId);
  }

  static List<Product> getWishlistProducts(List<Product> allProducts) {
    return allProducts.where((p) => wishlist.contains(p.id)).toList();
  }
}

// 🌿 Main Eco Products Screen
class EcoProducts extends StatefulWidget {
  const EcoProducts({super.key});

  @override
  State<EcoProducts> createState() => EcoProductsState();
}

class EcoProductsState extends State<EcoProducts> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedSort = 'Name A-Z';
  List<Product> products = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final fetchedProducts = await ProductService.getMockProducts();
    if (!mounted) return;
    setState(() {
      products = fetchedProducts;
      filteredProducts = List<Product>.from(fetchedProducts);
      sortProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      sortProducts();
    });
  }

  void sortProducts() {
    switch (selectedSort) {
      case 'Name A-Z':
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price Low-High':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'CO₂ Saved':
        filteredProducts.sort((a, b) => b.co2Saved.compareTo(a.co2Saved));
        break;
    }
  }

  void toggleWishlist(String productId) {
    setState(() {
      if (WishlistService.isInWishlist(productId)) {
        WishlistService.removeFromWishlist(productId);
      } else {
        WishlistService.addToWishlist(productId);
      }
    });
  }

  List<Product> getWishlistProducts() =>
      WishlistService.getWishlistProducts(products);

  void showWishlistDialog() {
    final wishlistItems = getWishlistProducts();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Wishlist',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(),
                if (wishlistItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'Your wishlist is empty 🌱',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                else
                  ...wishlistItems.map((product) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0xFFdfb163),
                        ),
                        onPressed: () {
                          toggleWishlist(product.id);
                          Navigator.pop(context);
                          showWishlistDialog();
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Fixed-height Product Card (no overflow)
  Widget buildProductCard(Product product, bool isWishlisted) {
    return Container(
      height: 270, // Fixed card height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼 Image section
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () => toggleWishlist(product.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted
                            ? const Color(0xFFdfb163)
                            : Colors.grey.shade600,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📝 Text + Button section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Text('🌿', style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 3),
                      Text(
                        '${product.co2Saved} kg CO₂',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          minimumSize: const Size(0, 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/ProductsDetails',
                            arguments: product,
                          );
                        },
                        child: const Text(
                          'Learn More',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      bottomNavigationBar: buildCustomBottomBar(context, 3),
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: const Color(0xFF2E7D32),
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(
                  'Eco Products',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                titlePadding: EdgeInsets.only(left: 20, bottom: 16),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 🔍 Search
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: filterProducts,
                        decoration: const InputDecoration(
                          hintText: 'Search eco products...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF2E7D32),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 🔽 Sort
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          isExpanded: true,
                          items: ['Name A-Z', 'Price Low-High', 'CO₂ Saved']
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedSort = newValue!;
                              sortProducts();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ✅ Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Better proportion
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = filteredProducts[index];
                  final isWishlisted = WishlistService.isInWishlist(product.id);
                  return buildProductCard(product, isWishlisted);
                }, childCount: filteredProducts.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/Wishlist'),
        backgroundColor: const Color(0xFF2E7D32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.favorite, color: Colors.white),
            if (WishlistService.wishlist.isNotEmpty)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFdfb163),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${WishlistService.wishlist.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
