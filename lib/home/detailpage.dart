import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDFFFE2), // soft green gradient base
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Reusable Bottle',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // --- Product Image ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'data:image/jpeg;base64,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',
                    height: size.height * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                // --- Product Name ---
                Text(
                  'Reusable Bottle',
                  style: TextStyle(
                    fontSize: size.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 8),

                // --- Points and Savings ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.eco, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    const Text(
                      '+50 Green Points',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.scale, color: Colors.green, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Saves 0.15 kg',
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // --- Price & Availability ---
                Text(
                  'Price: PKR 850',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Available in 3 colors 🌈',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // --- Description ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'A reusable stainless-steel bottle that helps reduce single-use plastic waste and keeps your drinks cool.',
                    style: TextStyle(fontSize: 15, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Benefits Section ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const BenefitItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  text: 'BPA-free and eco-packaged',
                ),
                const BenefitItem(
                  icon: Icons.water_drop,
                  color: Colors.green,
                  text: 'Reduces plastic waste',
                ),
                const BenefitItem(
                  icon: Icons.local_florist,
                  color: Colors.green,
                  text: 'Lightweight and durable',
                ),
                const SizedBox(height: 24),

                // --- Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green.shade700),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Add to Wishlist',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/BuyNow');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- Footer Message ---
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.eco, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Every purchase plants a future 🌱💚',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
