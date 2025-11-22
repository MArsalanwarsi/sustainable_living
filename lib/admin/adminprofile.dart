import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? email;
  String? role;
  String? uid;
  String? profile;

  // ========== DYNAMIC DATA VARIABLES (For Firebase Integration) ==========

  // Admin Statistics
  int totalChallenges = 32;
  int activeChallenges = 18;
  int totalPosts = 124;

  // User Growth Data (last 7 days)
  List<double> userGrowthData = [1200, 1210, 1215, 1220, 1230, 1235, 1245];
  List<String> growthLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // Platform Activity Data (last 6 months)
  List<double> monthlyActivity = [85, 92, 78, 105, 98, 112];
  List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  // Engagement Statistics
  double avgEngagementRate = 68.5;
  int totalCO2Saved = 1250; // kg
  int totalGreenPoints = 45000;

  //dynamic
  int userCount = 0;
  int productCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/Login');
    } else {
      uid = user?.uid;
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        DocumentSnapshot userDoc = await firestore
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          role = data['role'];
          if (role != 'admin') {
            Navigator.pushReplacementNamed(context, '/AdminDashboard');
          } else {
            name = data['name'];
            email = user?.email;
            profile = data['profile_image'];

            final usersSnap = await firestore.collection('users').get();
            userCount = usersSnap.size;
            final productSnap = await firestore.collection('Products').get();
            productCount = productSnap.size;
            setState(() {});
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching admin data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F5),
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== ADMIN PROFILE HEADER ==========
              _AdminProfileHeader(
                name: name ?? 'Admin',
                email: email ?? '',
                profileImage: profile,
              ),
              const SizedBox(height: 24),

              // ========== PLATFORM STATISTICS ==========
              const Text(
                "Platform Statistics 📊",
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
                    child: _AdminStatCard(
                      title: "Total Users",
                      value: '$userCount',
                      icon: Icons.people,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AdminStatCard(
                      title: "Active Users",
                      value: '$userCount',
                      icon: Icons.verified_user,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AdminStatCard(
                      title: "Challenges",
                      value: "$activeChallenges/$totalChallenges",
                      icon: Icons.flag,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AdminStatCard(
                      title: "Products",
                      value: '$productCount',
                      icon: Icons.shopping_bag,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ========== USER GROWTH CHART ==========
              const Text(
                "User Growth (Last 7 Days) 📈",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _UserGrowthChartCard(
                growthData: userGrowthData,
                labels: growthLabels,
              ),
              const SizedBox(height: 24),

              // ========== PLATFORM ACTIVITY CHART ==========
              const Text(
                "Platform Activity (Last 6 Months) 📊",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _PlatformActivityChartCard(
                activityData: monthlyActivity,
                labels: monthLabels,
              ),
              const SizedBox(height: 24),

              // ========== ENGAGEMENT METRICS ==========
              const Text(
                "Engagement Metrics 🌍",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _EngagementMetricsCard(
                avgEngagementRate: avgEngagementRate,
                totalCO2Saved: totalCO2Saved,
                totalGreenPoints: totalGreenPoints,
              ),
              const SizedBox(height: 24),

              // ========== ACTION BUTTONS ==========
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.edit,
                      label: "Edit Profile",
                      color: Colors.green.shade700,
                      onTap: () {
                        Navigator.pushNamed(context, '/EditProfile');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.logout,
                      label: "Log Out",
                      color: Colors.red.shade700,
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/Login');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// 👤 ADMIN PROFILE HEADER
class _AdminProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? profileImage;

  const _AdminProfileHeader({
    required this.name,
    required this.email,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage: profileImage != null && profileImage!.isNotEmpty
                  ? (profileImage!.startsWith('http')
                        ? NetworkImage(profileImage!)
                        : null)
                  : null,
              child: profileImage == null || profileImage!.isEmpty
                  ? Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.green.shade700,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "ADMIN",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 📊 ADMIN STAT CARD
class _AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 📈 USER GROWTH CHART CARD
class _UserGrowthChartCard extends StatelessWidget {
  final List<double> growthData;
  final List<String> labels;

  const _UserGrowthChartCard({required this.growthData, required this.labels});

  @override
  Widget build(BuildContext context) {
    double maxValue = growthData.reduce((a, b) => a > b ? a : b);
    maxValue = (maxValue * 1.1).ceilToDouble();
    double minValue = growthData.reduce((a, b) => a < b ? a : b);
    minValue = (minValue * 0.95).floorToDouble();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "User Growth",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "+${(growthData.last - growthData.first).toInt()} users",
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
                      reservedSize: 50,
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
                maxX: (growthData.length - 1).toDouble(),
                minY: minValue,
                maxY: maxValue,
                lineBarsData: [
                  LineChartBarData(
                    spots: growthData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue.shade700,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue.shade700,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade50,
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

/// 📊 PLATFORM ACTIVITY CHART CARD
class _PlatformActivityChartCard extends StatelessWidget {
  final List<double> activityData;
  final List<String> labels;

  const _PlatformActivityChartCard({
    required this.activityData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue = activityData.reduce((a, b) => a > b ? a : b);
    maxValue = (maxValue * 1.2).ceilToDouble();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Platform Activity",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${activityData.last.toInt()}%",
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
                minY: 0,
                maxY: maxValue,
                barGroups: activityData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Colors.green.shade700,
                        width: 30,
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

/// 🌍 ENGAGEMENT METRICS CARD
class _EngagementMetricsCard extends StatelessWidget {
  final double avgEngagementRate;
  final int totalCO2Saved;
  final int totalGreenPoints;

  const _EngagementMetricsCard({
    required this.avgEngagementRate,
    required this.totalCO2Saved,
    required this.totalGreenPoints,
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
              Icon(Icons.trending_up, color: Colors.green.shade700, size: 24),
              const SizedBox(width: 12),
              const Text(
                "Engagement Metrics",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: "Avg Engagement",
                  value: "${avgEngagementRate.toStringAsFixed(1)}%",
                  icon: Icons.people_outline,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  label: "Total CO₂ Saved",
                  value: "$totalCO2Saved kg",
                  icon: Icons.eco,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  label: "Green Points",
                  value: "${(totalGreenPoints / 1000).toStringAsFixed(1)}K",
                  icon: Icons.stars,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 📋 METRIC ITEM
class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// 🎯 ACTION BUTTON
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
