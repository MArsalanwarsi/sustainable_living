import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class EcoChallengesPage extends StatefulWidget {
  const EcoChallengesPage({super.key});

  @override
  State<EcoChallengesPage> createState() => _EcoChallengesPageState();
}

class _EcoChallengesPageState extends State<EcoChallengesPage> {
  String selectedFilter = "All";
  String selectedSort = "Default";
  String searchQuery = "";

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _challenges = [
    {
      'icon': Icons.directions_walk,
      'title': 'Walk 10,000 steps daily',
      'subtitle': 'Get your body moving',
      'points': 50,
      'isNew': false,
    },
    {
      'icon': Icons.water_drop,
      'title': 'Save 10L of water daily',
      'subtitle': 'Turn off tap while brushing',
      'points': 30,
      'isNew': false,
    },
    {
      'icon': Icons.lightbulb_outline,
      'title': 'Turn off lights when leaving room',
      'subtitle': 'Save energy',
      'points': 25,
      'isNew': true,
    },
    {
      'icon': Icons.recycling,
      'title': 'Recycle household waste',
      'subtitle': 'Sort recyclables properly',
      'points': 40,
      'isNew': true,
    },
  ];

  List<Map<String, dynamic>> get filteredChallenges {
    List<Map<String, dynamic>> list = _challenges.where((challenge) {
      final query = searchQuery.toLowerCase();
      return challenge['title'].toLowerCase().contains(query) ||
          challenge['subtitle'].toLowerCase().contains(query);
    }).toList();

    switch (selectedSort) {
      case 'Points ↑':
        list.sort((a, b) => a['points'].compareTo(b['points']));
        break;
      case 'Points ↓':
        list.sort((a, b) => b['points'].compareTo(a['points']));
        break;
      case 'A-Z':
        list.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case 'Z-A':
        list.sort((a, b) => b['title'].compareTo(a['title']));
        break;
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context),
      bottomNavigationBar: buildCustomBottomBar(context, 2),
      backgroundColor: Colors.green.shade50,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                "♻️ Eco Challenges",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Join green missions and earn rewards 💚",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
                decoration: InputDecoration(
                  hintText: "Search challenges...",
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.green),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchQuery = "");
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Featured Challenge
              const FeaturedChallengeCard(),
              const SizedBox(height: 24),

              // Filters + Sorting Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var filter in [
                          "All",
                          "Ongoing",
                          "Completed",
                          "New",
                        ])
                          ChoiceChip(
                            label: Text(filter),
                            selected: selectedFilter == filter,
                            onSelected: (_) {
                              setState(() => selectedFilter = filter);
                            },
                            selectedColor: Colors.green,
                            labelStyle: TextStyle(
                              color: selectedFilter == filter
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            backgroundColor: Colors.white,
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        icon: const Icon(Icons.sort, color: Colors.green),
                        onSelected: (value) {
                          setState(() => selectedSort = value);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "Default",
                            child: Text("Default"),
                          ),
                          const PopupMenuItem(
                            value: "Points ↑",
                            child: Text("Points ↑"),
                          ),
                          const PopupMenuItem(
                            value: "Points ↓",
                            child: Text("Points ↓"),
                          ),
                          const PopupMenuItem(value: "A-Z", child: Text("A-Z")),
                          const PopupMenuItem(value: "Z-A", child: Text("Z-A")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Challenges List
              Expanded(
                child: filteredChallenges.isEmpty
                    ? const Center(
                        child: Text(
                          "No challenges found 😕",
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: filteredChallenges.length,
                        itemBuilder: (context, index) {
                          final challenge = filteredChallenges[index];
                          return ChallengeCard(
                            icon: challenge['icon'],
                            title: challenge['title'],
                            subtitle: challenge['subtitle'],
                            points: challenge['points'],
                            isNew: challenge['isNew'],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturedChallengeCard extends StatelessWidget {
  const FeaturedChallengeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "30-Day Plastic-Free Challenge ♻️",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Avoid single-use plastic and save the planet 🌍",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.6,
            color: Colors.green,
            backgroundColor: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
            minHeight: 6,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("12 days left", style: TextStyle(color: Colors.black54)),
              Text(
                "Reward: +200 points 💚",
                style: TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: const Size(double.infinity, 42),
            ),
            onPressed: () {},
            child: const Text(
              "Continue Challenge",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int points;
  final bool isNew;

  const ChallengeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.points,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade50,
                  child: Icon(icon, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isNew)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "NEW",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            "+$points pts",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
