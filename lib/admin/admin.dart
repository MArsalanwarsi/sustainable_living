import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- Statistics ----------------
            const Text(
              "Statistics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: _StatCard(title: "Users", value: "1,245", icon: Icons.people)),
                SizedBox(width: 8),
                Expanded(child: _StatCard(title: "Challenges", value: "32", icon: Icons.flag)),
                SizedBox(width: 8),
                Expanded(child: _StatCard(title: "Tips", value: "58", icon: Icons.lightbulb_outline)),
                SizedBox(width: 8),
                Expanded(child: _StatCard(title: "Forum", value: "124", icon: Icons.forum)),
              ],
            ),
            const SizedBox(height: 24),

            // ---------------- Analytics ----------------
            const Text(
              "Analytics",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: _LineChartCard()),
                SizedBox(width: 12),
                Expanded(child: _BarChartCard()),
              ],
            ),
            const SizedBox(height: 24),

            // ---------------- Recent Activity ----------------
            const Text(
              "Recent Activity Log",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  _ActivityItem("Saqib joined Water Saver Challenge"),
                  _ActivityItem("New tip 'Save Water at Home' posted"),
                  _ActivityItem("5 forum posts approved"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ---------------- Quick Actions ----------------
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Single Row for All Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: _QuickButton(icon: Icons.flag, label: "Add Challenge")),
                SizedBox(width: 8),
                Expanded(child: _QuickButton(icon: Icons.lightbulb_outline, label: "Add Tip")),
                SizedBox(width: 8),
                Expanded(child: _QuickButton(icon: Icons.people, label: "Manage Users")),
                SizedBox(width: 8),
                Expanded(child: _QuickButton(icon: Icons.forum, label: "Forum")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- STAT CARD --------------------
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green.shade600, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// -------------------- LINE CHART --------------------
class _LineChartCard extends StatelessWidget {
  const _LineChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CO₂ Saved Per Week",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.2),
                    ),
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(1, 3.5),
                      FlSpot(2, 3),
                      FlSpot(3, 4),
                      FlSpot(4, 4.5),
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
}

// -------------------- BAR CHART --------------------
class _BarChartCard extends StatelessWidget {
  const _BarChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Challenges Joined Per Day",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 2, color: Colors.green.shade400)
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 3, color: Colors.green.shade400)
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 4, color: Colors.green.shade400)
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 5, color: Colors.green.shade400)
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- ACTIVITY ITEM --------------------
class _ActivityItem extends StatelessWidget {
  final String text;
  const _ActivityItem(this.text);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
      title: Text(text, style: const TextStyle(fontSize: 14)),
      contentPadding: EdgeInsets.zero,
    );
  }
}

// -------------------- QUICK BUTTON --------------------
class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _QuickButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          alignment: Alignment.center,
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
