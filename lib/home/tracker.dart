import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class TrackerHome extends StatefulWidget {
  const TrackerHome({super.key});

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> {
  double totalCO2 = 0;
  double yearCO2 = 0;
  String impactLevel = '';
  String suggestion = '';
  String yearlyImpact = '';
  String yearlySuggestion = '';
  String transportMode = '';
  double distance = 0;
  double electricityHours = 0;
  double showerMinutes = 0;
  String foodType = '';
  bool usedPlastic = false;
  bool recycledWaste = false;
  int Green_Points = 0;

  @override
  void initState() {
    super.initState();
    getvalues();
  }

  void getvalues() async {
    // firebase firestore get the values of the user's carbon calculations
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('carbon_calculations')
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = querySnapshot.docs.first;
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        totalCO2 = data['total_co2'];
        yearCO2 = data['yearly_co2'];
        impactLevel = data['impact_level'];
        suggestion = data['suggestion'];
        yearlyImpact = data['yearly_impact'];
        yearlySuggestion = data['yearly_suggestion'];
        transportMode = data['transport_mode'];
        distance = data['distance'];
        electricityHours = data['electricity_hours'];
        showerMinutes = data['shower_minutes'];
        foodType = data['food_type'];
        usedPlastic = data['used_plastic'];
        recycledWaste = data['recycled_waste'];
        Green_Points = data['Green_Points'];
        setState(() {});
      }
    }
  }

  // Daily CO2 consumed data (last 7 days)
  List<double> dailyCo2Consumed = [4.2, 3.8, 5.1, 4.5, 3.9, 4.7, 4.3];
  List<String> dailyLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Yearly CO2 consumed data (12 months)
  List<double> yearlyCo2Consumed = [
    125.5,
    118.2,
    132.4,
    128.6,
    135.8,
    142.3,
    138.9,
    145.2,
    140.6,
    148.1,
    152.4,
    160.8,
  ];
  List<String> monthlyLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // CO2 Saved and Green Points from different sources
  double co2SavedFromTasks = 8.5; // CO2 saved through tasks
  double co2SavedFromPlanting = 3.9; // CO2 saved through planting trees
  double totalCo2Saved = 12.4; // Total CO2 saved

  int greenPointsFromTasks = 320; // Green points from tasks
  int greenPointsFromPlanting = 200; // Green points from planting
  int totalGreenPoints = 520; // Total green points

  // Current day and month for charts
  int selectedDayIndex = 6; // Last day (Sunday)
  int selectedMonthIndex = 11; // December

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      appBar: buildCustomAppBar(context),
      bottomNavigationBar: buildCustomBottomBar(context, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/calculator');
        },
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.calculate, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== CHARTS SECTION ==========
            const Text(
              "CO₂ Consumption Charts 📊",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Daily CO2 Consumed Chart
            _DailyCo2ChartCard(
              dailyData: dailyCo2Consumed,
              labels: dailyLabels,
            ),
            const SizedBox(height: 16),

            // Yearly CO2 Consumed Chart
            _YearlyCo2ChartCard(
              yearlyData: yearlyCo2Consumed,
              labels: monthlyLabels,
            ),
            const SizedBox(height: 24),

            // ========== CO2 SAVED & GREEN POINTS SUMMARY ==========
            const Text(
              "Your Impact Summary 🌍",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // CO2 Saved Breakdown
            _ImpactBreakdownCard(
              title: "CO₂ Saved",
              totalValue: totalCo2Saved,
              fromTasks: co2SavedFromTasks,
              fromPlanting: co2SavedFromPlanting,
              unit: "kg",
              icon: Icons.eco,
            ),
            const SizedBox(height: 16),

            // Green Points Breakdown
            _ImpactBreakdownCard(
              title: "Green Points Earned",
              totalValue: totalGreenPoints.toDouble(),
              fromTasks: greenPointsFromTasks.toDouble(),
              fromPlanting: greenPointsFromPlanting.toDouble(),
              unit: "pts",
              icon: Icons.stars,
            ),
            const SizedBox(height: 24),

            // ========== QUICK ACTIONS SECTION ==========
            const Text(
              "Take Action 🌿",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _ActionNavigationCard(
                    title: "Plant Trees",
                    subtitle: "Offset your carbon",
                    icon: Icons.park,
                    color: Colors.green.shade700,
                    onTap: () {
                      // Navigate to plant trees page
                      // Navigator.pushNamed(context, '/plant-trees');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionNavigationCard(
                    title: "Eco Products",
                    subtitle: "Shop sustainably",
                    icon: Icons.shopping_bag,
                    color: Colors.green.shade600,
                    onTap: () {
                      // Navigate to eco products page
                      Navigator.pushReplacementNamed(context, '/Products');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _ActionNavigationCard(
              title: "Learn More",
              subtitle: "Discover sustainability tips & guides",
              icon: Icons.school,
              color: Colors.green.shade500,
              onTap: () {
            
              },
              isFullWidth: true,
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }
}

/// 📈 DAILY CO2 CONSUMED CHART CARD
class _DailyCo2ChartCard extends StatelessWidget {
  final List<double> dailyData;
  final List<String> labels;

  const _DailyCo2ChartCard({required this.dailyData, required this.labels});

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    double maxValue = dailyData.reduce((a, b) => a > b ? a : b);
    maxValue = (maxValue * 1.2).ceilToDouble(); // Add 20% padding

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily CO₂ Consumed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${dailyData.last.toStringAsFixed(1)} kg",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    left: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                minX: 0,
                maxX: (dailyData.length - 1).toDouble(),
                minY: 0,
                maxY: maxValue,
                lineBarsData: [
                  LineChartBarData(
                    spots: dailyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.green.shade700,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.green.shade700,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.shade50,
                    ),
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

/// 📊 YEARLY CO2 CONSUMED CHART CARD
class _YearlyCo2ChartCard extends StatelessWidget {
  final List<double> yearlyData;
  final List<String> labels;

  const _YearlyCo2ChartCard({required this.yearlyData, required this.labels});

  @override
  Widget build(BuildContext context) {
    // Find max value for scaling
    double maxValue = yearlyData.reduce((a, b) => a > b ? a : b);
    maxValue = (maxValue * 1.2).ceilToDouble(); // Add 20% padding

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Yearly CO₂ Consumed",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${yearlyData.last.toStringAsFixed(1)} kg",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                    left: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                minY: 0,
                maxY: maxValue,
                barGroups: yearlyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Colors.green.shade700,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🌍 IMPACT BREAKDOWN CARD
class _ImpactBreakdownCard extends StatelessWidget {
  final String title;
  final double totalValue;
  final double fromTasks;
  final double fromPlanting;
  final String unit;
  final IconData icon;

  const _ImpactBreakdownCard({
    required this.title,
    required this.totalValue,
    required this.fromTasks,
    required this.fromPlanting,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total Value
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${totalValue.toStringAsFixed(1)} $unit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Breakdown
          _BreakdownItem(
            label: "From Tasks",
            value: fromTasks,
            unit: unit,
            color: Colors.green.shade600,
          ),
          const SizedBox(height: 12),
          _BreakdownItem(
            label: "From Planting",
            value: fromPlanting,
            unit: unit,
            color: Colors.green.shade500,
          ),
        ],
      ),
    );
  }
}

/// 📋 BREAKDOWN ITEM
class _BreakdownItem extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;

  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
        Text(
          "${value.toStringAsFixed(1)} $unit",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// 🎯 ACTION NAVIGATION CARD
class _ActionNavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _ActionNavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}
