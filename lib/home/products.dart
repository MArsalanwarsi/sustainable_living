import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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

  static Future<void> syncWishlistToCloud(
    String productId,
    bool shouldAdd,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('Wishlist')
        .doc(productId);

    try {
      if (shouldAdd) {
        await docRef.set({
          'productId': productId,
          'addedAt': FieldValue.serverTimestamp(),
        });
      } else {
        await docRef.delete();
      }
    } catch (e) {
      debugPrint('Wishlist cloud sync error: $e');
    }
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => isLoading = true);
    final fetchedProducts = await ProductService.getMockProducts();
    if (!mounted) return;
    setState(() {
      products = fetchedProducts;
      filteredProducts = List<Product>.from(fetchedProducts);
      sortProducts();
      isLoading = false;
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

  Future<void> toggleWishlist(String productId) async {
    final shouldAdd = !WishlistService.isInWishlist(productId);
    setState(() {
      if (shouldAdd) {
        WishlistService.addToWishlist(productId);
      } else {
        WishlistService.removeFromWishlist(productId);
      }
    });
    await WishlistService.syncWishlistToCloud(productId, shouldAdd);
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
                        onPressed: () async {
                          await toggleWishlist(product.id);
                          if (!context.mounted) return;
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

  Widget buildHighlightChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeroBanner(int crossAxisCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF65B741)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              buildHighlightChip('Certified eco brands', Icons.verified),
              buildHighlightChip(
                'Fast carbon-neutral shipping',
                Icons.local_fire_department,
              ),
              buildHighlightChip('Earn green points', Icons.spa),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Discover products that care for you and the planet.',
            style: TextStyle(
              fontSize: crossAxisCount >= 3 ? 28 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Curated essentials that offset CO₂, recycle responsibly, and reward sustainable choices. Updated daily from our partner makers.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchAndSortCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7F2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: searchController,
              onChanged: filterProducts,
              decoration: const InputDecoration(
                hintText: 'Search eco innovations, categories, makers...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF2E7D32)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE1E8E1)),
            ),
            child: DropdownButtonHideUnderline(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                child: DropdownButton<String>(
                  value: selectedSort,
                  borderRadius: BorderRadius.circular(18),
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: Color(0xFF2E7D32)),
                  items: ['Name A-Z', 'Price Low-High', 'CO₂ Saved']
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              value,
                              style: const TextStyle(
                                color: Color(0xFF1A421E),
                                fontWeight: FontWeight.w600,
                              ),
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
          ),
        ],
      ),
    );
  }

  Widget buildStatsRow() {
    final totalCo2 = products.fold<double>(
      0,
      (sum, item) => sum + item.co2Saved,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cards = [
          _StatCard(
            title: 'Products live',
            value: products.length.toString(),
            icon: Icons.eco_outlined,
            color: const Color(0xFF2E7D32),
          ),
          _StatCard(
            title: 'Annual CO₂ offset',
            value: '${totalCo2.toStringAsFixed(1)} kg',
            icon: Icons.public,
            color: const Color(0xFF65B741),
          ),
          _StatCard(
            title: 'Wishlist saved',
            value: WishlistService.wishlist.length.toString(),
            icon: Icons.favorite,
            color: const Color(0xFFdfb163),
          ),
        ];

        if (isWide) {
          return Row(
            children: cards
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: card,
                    ),
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: cards
              .map(
                (card) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: card,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget buildProductCard(Product product, bool isWishlisted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWishlisted
              ? const Color(0xFFdfb163).withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFE7EFE5),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Color(0xFF9AA49B),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFFE7EFE5),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                            color: Color(0xFF2E7D32),
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => toggleWishlist(product.id),
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted
                            ? const Color(0xFFdfb163)
                            : const Color(0xFF5E6F63),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.energy_savings_leaf_outlined,
                          size: 14,
                          color: Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${product.greenPoints.toStringAsFixed(0)} pts',
                          style: const TextStyle(
                            color: Color(0xFF1A421E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A421E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.spa_outlined,
                        size: 14,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Save ${product.co2Saved.toStringAsFixed(1)} kg CO₂',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A421E),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          backgroundColor: const Color(0xFF2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                          'Learn more',
                          style: TextStyle(
                            fontSize: 12,
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
      backgroundColor: const Color(0xFFEFF4ED),
      bottomNavigationBar: buildCustomBottomBar(context, 3),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 700;
          final isDesktop = constraints.maxWidth >= 1100;
          final crossAxisCount = isDesktop
              ? 4
              : isTablet
              ? 3
              : 2;
          final childAspectRatio = isDesktop
              ? 0.85
              : isTablet
              ? 0.8
              : 0.72;

          return RefreshIndicator(
            color: const Color(0xFF2E7D32),
            onRefresh: loadProducts,
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 160,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2E7D32), Color(0xFF1C5C28)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(32),
                        ),
                      ),
                      child: const FlexibleSpaceBar(
                        titlePadding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        title: Text(
                          'Eco Products',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Column(
                        children: [
                          buildHeroBanner(crossAxisCount),
                          const SizedBox(height: 20),
                          buildSearchAndSortCard(),
                          const SizedBox(height: 20),
                          buildStatsRow(),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    )
                  else if (filteredProducts.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              color: Color(0xFF9AA49B),
                              size: 96,
                            ),
                            SizedBox(height: 24),
                            Text(
                              'No matches found',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A421E),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try refining your search or explore another category of eco essentials.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF5E6F63)),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: childAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = filteredProducts[index];
                          final isWishlisted = WishlistService.isInWishlist(
                            product.id,
                          );
                          return buildProductCard(product, isWishlisted);
                        }, childCount: filteredProducts.length),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/Wishlist'),
        backgroundColor: const Color(0xFF2E7D32),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            const Icon(Icons.favorite, color: Colors.white),
            if (WishlistService.wishlist.isNotEmpty)
              Positioned(
                right: -2,
                top: -2,
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xFF5E6F63)),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A421E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
