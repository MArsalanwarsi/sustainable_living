import 'package:flutter/material.dart';


class PlasticFreeChallengeScreen extends StatelessWidget {
  const PlasticFreeChallengeScreen({super.key});

  // Theme colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color softWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double scale(double size) {
      if (screenWidth < 360) return size * 0.75;
      if (screenWidth < 420) return size * 0.85;
      return size;
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.recycling, color: primaryGreen, size: 26),
                    SizedBox(width: 6),
                    Text(
                      'Plastic-Free Challenge',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  '30-day mission to reduce plastic waste 🌍',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Overview
                _buildOverviewCard(scale),

                const SizedBox(height: 20),

                // Progress
                _buildProgressCard(),

                const SizedBox(height: 16),

                // Tip Card
                _buildTipCard(),

                const SizedBox(height: 16),

                // Reward Card
                _buildRewardCard(),

                const SizedBox(height: 24),

                // Bottom Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.exit_to_app_outlined,
                            color: primaryGreen),
                        label: const Text(
                          'Leave Challenge',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 20),
                        label: const Text(
                          'Back to Challenges',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  'Keep going! Small changes create big impact ♻️',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- UI SECTION ----------------

  Widget _buildOverviewCard(double Function(double) scale) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: softWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: const Text(
              'Overview',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: primaryGreen,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              children: [
                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: OverviewItem(
                        title: 'Reward',
                        value: '+200 Points',
                        icon: Icons.card_giftcard,
                        scale: scale,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OverviewItem(
                        title: 'Difficulty',
                        value: 'Medium',
                        icon: Icons.trending_up,
                        scale: scale,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 28, thickness: 1, color: Color(0xFFF0F0F0)),

                // Row 2 (4 items)
                Row(
                  children: [
                    Expanded(
                      child: OverviewItem(
                        title: 'Duration',
                        value: '30 Days',
                        icon: Icons.calendar_today,
                        scale: scale,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OverviewItem(
                        title: 'Status',
                        value: 'Ongoing',
                        icon: Icons.timelapse,
                        scale: scale,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OverviewItem(
                        title: 'Participants',
                        value: '120',
                        icon: Icons.group,
                        scale: scale,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OverviewItem(
                        title: 'Eco Level',
                        value: 'Level 3',
                        icon: Icons.eco,
                        scale: scale,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your progress: 12/30 days completed',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: 12 / 30,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    color: accentGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text('Mark Today'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: softWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.water_drop_outlined, color: primaryGreen),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Carry your own bottle instead of buying plastic.',
              style: TextStyle(fontSize: 15, color: Colors.black87),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRewardCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Reward',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: primaryGreen,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            'Complete this challenge to earn +200 Green Points and an Eco Hero Badge.',
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
        trailing: Icon(Icons.emoji_events, color: accentGreen),
      ),
    );
  }
}

// ---------------- REUSABLE OVERVIEW ITEM ----------------

class OverviewItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double Function(double) scale;

  const OverviewItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: scale(18)),
        const SizedBox(width: 4),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: scale(12),
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: scale(14),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
