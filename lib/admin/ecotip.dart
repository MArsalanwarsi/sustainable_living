import 'package:flutter/material.dart';

class AdminTipsListScreen extends StatefulWidget {
  const AdminTipsListScreen({super.key});

  @override
  State<AdminTipsListScreen> createState() => _AdminTipsListScreenState();
}

class _AdminTipsListScreenState extends State<AdminTipsListScreen> {
  String selectedSort = "Newest";

  final List<Map<String, dynamic>> tips = [
    {
      "title": "Take 5-minute showers",
      "category": "Water Saving",
      "created": "2025-10-01",
    },
    {
      "title": "Use reusable bags",
      "category": "Plastic-Free",
      "created": "2025-09-26",
    },
    {
      "title": "Switch to LED bulbs",
      "category": "Energy Saving",
      "created": "2025-08-12",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3FFAB),
      appBar: AppBar(
        title: const Text("Manage Eco Tips"),
        backgroundColor: Colors.green.shade700,
      ),

      /// ➕ Add Tip Floating Button (Static)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add Eco Tip UI will be added later 🌿"),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Tip"),
        backgroundColor: Colors.green.shade700,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔎 Search Bar
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
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search eco tips...",
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// 🔽 Sort Dropdown
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
                        "Category A-Z",
                        "Category Z-A",
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

            const SizedBox(height: 16),

            /// 📝 Eco Tips List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tips.length,
              itemBuilder: (context, index) {
                final tip = tips[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          /// Tip Icon
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(Icons.tips_and_updates_outlined,
                                color: Colors.green.shade700, size: 28),
                          ),

                          const SizedBox(width: 12),

                          /// Title + Category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip["title"],
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  tip["category"],
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Added: ${tip["created"]}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// ACTION BUTTONS → View | Edit | Delete
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// VIEW
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("View Tip feature coming soon 🌿")),
                              );
                            },
                            icon: const Icon(Icons.visibility,
                                color: Colors.blue),
                          ),

                          /// EDIT
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Edit Tip feature coming soon 📝")),
                              );
                            },
                            icon:
                                const Icon(Icons.edit, color: Colors.orange),
                          ),

                          /// DELETE
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Delete '${tip["title"]}' will work after Firebase setup 🚮"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
