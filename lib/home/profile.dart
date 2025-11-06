import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? name;
  String? email;
  String? role;
  String? uid;
  String? profile;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/Login');
    } else {
      uid = user?.uid;
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>;
          role = data['role'];
          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/AdminDashboard');
          } else {
            name = data['name'];
            email = user?.email;
            profile = data['profile_image'];
            setState(() {});
          }
        }
      } catch (e) {
        // Handle any errors that might occur during the fetch
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4EA),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/name.png', height: 58, fit: BoxFit.contain),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pushReplacementNamed(context, '/Home'),
        ),
      ),
      bottomNavigationBar: buildCustomBottomBar(context, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green,
                backgroundImage: profile != null
                    ? (profile!.startsWith('http')
                          ? NetworkImage(profile!)
                          : null)
                    : null,
                child: (profile == null || profile == '')
                    ? Icon(Icons.person, size: 60, color: Colors.green.shade700)
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                name ?? 'User Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 5),
              Text(email ?? '', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),

              // Eco Stats Card
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.eco, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Eco Stats',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Expanded(
                          child: _StatItem(
                            label: 'CO₂ Saved',
                            value: '12.4 kg',
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.withValues(alpha: 0.4),
                        ),
                        const Expanded(
                          child: _StatItem(label: 'Green Points', value: '520'),
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.withValues(alpha: 0.4),
                        ),
                        const Expanded(
                          child: _StatItem(label: 'Challenges', value: '8'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Badges Earned
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Badges Earned',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _BadgeItem('Green Starter', Icons.spa, Colors.green),
                  _BadgeItem('Water Saver', Icons.water_drop, Colors.blue),
                  _BadgeItem('Eco Mover', Icons.directions_bike, Colors.green),
                  _BadgeItem(
                    'Energy Hero',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Centered Buttons
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/EditProfile');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/Selection');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _BadgeItem(this.text, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
