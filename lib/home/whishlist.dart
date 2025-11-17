import 'package:flutter/material.dart';

/// 🌱 Wishlist Screen
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  // Theme colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color softWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> products = [
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/2674/2674898.png',
        'title': 'Reusable Water Bottle',
        'subtitle': 'Avoid single-use plastic',
        'badge': '+50 Points',
      },
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/4273/4273585.png',
        'title': 'Solar Pathway Light',
        'subtitle': 'Save energy daily',
        'badge': '+50 Points',
      },
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/3661/3661909.png',
        'title': 'Organic Cotton Bag',
        'subtitle': 'Reduce waste',
        'badge': '+50 Points',
      },
      {
        'image': 'https://cdn-icons-png.flaticon.com/512/4151/4151322.png',
        'title': 'Bamboo Toothbrushes',
        'subtitle': 'Sustainable dental care',
        'badge': 'Saves 0.5 kg CO₂',
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final bool isSmall = width < 360;
            final bool isLarge = width > 600;
            final int crossAxisCount = isLarge ? 3 : 2;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isSmall ? 12 : 20,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ---------------- HEADER ----------------
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: isSmall ? 14 : 18,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'My Wishlist 💚',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'You have 4 saved products 🌿',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------------- PRODUCT GRID ----------------
                      GridView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: isSmall
                              ? 0.65
                              : isLarge
                              ? 0.95
                              : 0.80,
                        ),
                        itemBuilder: (context, index) {
                          final item = products[index];
                          return _ProductCard(
                            image: item['image']!,
                            title: item['title']!,
                            subtitle: item['subtitle']!,
                            badge: item['badge']!,
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // ---------------- FOOTER ----------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: softWhite,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.eco, color: primaryGreen),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Keep going! Every eco purchase brings us closer to a greener planet 💚',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 🪴 Product Card Widget
class _ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String badge;

  const _ProductCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: WishlistScreen.softWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WishlistScreen.lightGreen, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Image.network(image, height: 60, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                color: WishlistScreen.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 12.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: WishlistScreen.lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: WishlistScreen.accentGreen,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 12,
                      color: WishlistScreen.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🗑 Delete Button
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item removed from wishlist 💔'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete_outline,
                      color: WishlistScreen.primaryGreen,
                      size: 22,
                    ),
                  ),
                ),

                // 💳 Buy Now Button
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Redirecting to Buy Now page 💳'),
                        duration: Duration(seconds: 1),
                      ),
                    );

                    // TODO: Replace with your navigation or payment logic
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => BuyNowScreen()));
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: WishlistScreen.primaryGreen,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
