import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: buildCustomAppBar(context),
      backgroundColor: const Color(0xFFE9F5EC),
      bottomNavigationBar: buildCustomBottomBar(context, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                "Hello, ${name ?? 'User'} 🌿",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Let’s make today a greener day 🍃",
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              const SizedBox(height: 20),

              // Daily Eco Tip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.green,
                      size: 28,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "💡 Daily Eco Tip:\nUse reusable bags!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildStatBox("CO₂ Saved", "65%"),
                  buildStatBox("Green Points", "350 pts"),
                  buildStatBox("Challenges", "3/5"),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildActionButton(Icons.eco, "Tracker"),
                  buildActionButton(Icons.flag, "Challenges"),
                  buildActionButton(Icons.shopping_bag, "Products"),
                  buildActionButton(Icons.forum, "Forum"),
                ],
              ),
              const SizedBox(height: 20),

              // Featured Challenge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Featured Challenge",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Plastic-Free Week",
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const LinearProgressIndicator(
                      value: 0.4,
                      minHeight: 8,
                      color: Colors.green,
                      backgroundColor: Color(0xFFD7F3DA),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Join",
                          style: TextStyle(color: Colors.white), // ✅ White text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Latest Eco News
              const Text(
                "🌱 Latest Eco News",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    buildNewsCard(
                      "Community Solar Initiatives",
                      "assets/solar.jpg",
                    ),
                    buildNewsCard("Eco Coffee Cups", "assets/cup.jpg"),
                    buildNewsCard(
                      "Green Transport Ideas",
                      "assets/transport.jpg",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Footer
              const Center(
                child: Text(
                  "Small steps lead to big change 🌍",
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper UI Widgets (still simple and inline)
  Widget buildStatBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildActionButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNewsCard(String title, String imagePath) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
