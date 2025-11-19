import 'package:flutter/material.dart';

class AdminChallengeListScreen extends StatefulWidget {
  const AdminChallengeListScreen({super.key});

  @override
  State<AdminChallengeListScreen> createState() =>
      _AdminChallengeListScreenState();
}

class _AdminChallengeListScreenState extends State<AdminChallengeListScreen> {
  String selectedSort = "Newest";

  final List<Map<String, dynamic>> challenges = [
    {
      "title": "Plastic-Free Week",
      "subtitle": "Avoid plastic for 7 days",
      "icon": Icons.recycling,
    },
    {
      "title": "Save Water Challenge",
      "subtitle": "Reduce shower time",
      "icon": Icons.water_drop_outlined,
    },
    {
      "title": "Bike to Work",
      "subtitle": "Use bicycle instead of car",
      "icon": Icons.pedal_bike,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3FFAB),
      appBar: AppBar(
        title: const Text("Manage Challenges"),
        backgroundColor: Colors.green.shade700,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add Challenge will work after Firebase setup 🌿"),
            ),
          );
        },
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.add),
        label: const Text("Add New"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search challenges...",
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// Sorting Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: selectedSort,
                      items: [
                        "Newest",
                        "Oldest",
                        "A - Z",
                        "Z - A",
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedSort = val!);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Challenge List
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final item = challenges[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// ICON
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          item["icon"],
                          color: Colors.green.shade700,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// TEXT COLUMN
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"],
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["subtitle"],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),

                      /// EDIT BUTTON
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Edit feature will be added after Firebase setup 🌿"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),

                      /// DELETE BUTTON
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Delete '${item["title"]}' will work with Firebase later 🗑️"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
