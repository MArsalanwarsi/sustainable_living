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
  DocumentSnapshot? tipDoc;
  int greenpoint = 0;

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
            // Get latest tip from Firebase Tips collection, ordered by 'created' (descending)
            final tipsQuery = await FirebaseFirestore.instance
                .collection('Tips')
                .orderBy('created', descending: true)
                .limit(1)
                .get();

            tipDoc = tipsQuery.docs.isNotEmpty ? tipsQuery.docs.first : null;
            // Get the green points from the users/{uid}/carbon_calculations/{uid} document for this user
            if (uid != null && uid!.isNotEmpty) {
              final calculationDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('carbon_calculations')
                  .limit(1)
                  .get();
              if (calculationDoc.docs.isNotEmpty) {
                final calculationData = calculationDoc.docs.first.data() as Map<String, dynamic>?;
                if (calculationData != null && calculationData.containsKey('Green_Points')) {
                  greenpoint = calculationData['Green_Points'] is int
                      ? calculationData['Green_Points']
                      : int.tryParse(calculationData['Green_Points']?.toString() ?? '0') ?? 0;
                } else {
                  greenpoint = 0;
                }
              } else {
                greenpoint = 0;
              }
            } else {
              greenpoint = 0;
            }
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
    String ecoTip = "Fetching daily tip...";
    if (tipDoc != null) {
      final tipData = tipDoc!.data();
      if (tipData is Map && tipData.containsKey('description')) {
        // Ensure that tipData['description'] is a String or can be toString()-ed
        ecoTip =
            tipData['title']?.toString() ?? "No daily tip available.";
      } else {
        ecoTip = "No daily tip available.";
      }
    } else {
      ecoTip = "No daily tip available.";
    }

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
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.green,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "💡 Daily Eco Tip:\n$ecoTip",
                        style: const TextStyle(fontSize: 16),
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
                  buildStatBox("Green Points", "$greenpoint pts"),
                  buildStatBox("Challenges", "3/5"),
                ],
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildActionButton(Icons.eco, "Tracker", "/tracker", context),
                  buildActionButton(
                    Icons.flag,
                    "Challenges",
                    "/Challenges",
                    context,
                  ),
                  buildActionButton(
                    Icons.shopping_bag,
                    "Products",
                    "/Products",
                    context,
                  ),
                  buildActionButton(Icons.forum, "Forum", "/Form", context),
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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Feeds')
                          .orderBy('createdDate', descending: true)
                          .limit(3)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Row(
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SizedBox(
                                  width: 180,
                                  height: 120,
                                  child: Card(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text("Error loading news.");
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No news found.");
                        }
                        final feeds = snapshot.data!.docs;
                        return Row(
                          children: feeds.map<Widget>((doc) {
                            final fullTitle = (doc['title'] ?? '').toString();
                            final words = fullTitle.split(' ');
                            final title = words.length > 3
                                ? '${words.take(3).join(' ')}...'
                                : fullTitle;
                            final imageUrl = (doc['imageUrl'] ?? '');
                            return buildNewsCard(title, imageUrl);
                          }).toList(),
                        );
                      },
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

  Widget buildActionButton(
    IconData icon,
    String label,
    String routeName,
    BuildContext context,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        },
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
            child: Image.network(
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
