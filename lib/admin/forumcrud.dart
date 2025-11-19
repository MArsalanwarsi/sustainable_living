import 'package:flutter/material.dart';

class AdminForumListScreen extends StatefulWidget {
  const AdminForumListScreen({super.key});

  @override
  State<AdminForumListScreen> createState() => _AdminForumListScreenState();
}

class _AdminForumListScreenState extends State<AdminForumListScreen> {
  String selectedSort = "Newest";

  final List<Map<String, dynamic>> posts = [
    {
      "title": "How to reduce plastic at home?",
      "user": "Saqib Ahmed",
      "category": "Recycling",
      "status": "Pending",
      "image": "assets/sample.jpg",
    },
    {
      "title": "Energy saving tips for students",
      "user": "Ali Khan",
      "category": "Energy Saving",
      "status": "Approved",
    },
    {
      "title": "Is cycling better than walking?",
      "user": "Ayesha",
      "category": "Transport",
      "status": "Reported",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC3FFAB),
      appBar: AppBar(
        title: const Text("Manage Forum"),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ➕ ADD NEW POST BUTTON
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Create Post UI coming soon..."),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add New Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

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
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search posts...",
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// 🔽 Sort Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                      items: ["Newest", "Oldest", "A - Z", "Z - A"]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedSort = val!),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 📄 Forum Posts List
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons.forum_outlined,
                              color: Colors.green.shade700,
                              size: 26,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${post["user"]} • ${post["category"]}",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Status: ${post["status"]}",
                                  style: TextStyle(
                                    color: post["status"] == "Approved"
                                        ? Colors.green
                                        : post["status"] == "Reported"
                                            ? Colors.red
                                            : Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// ACTION BUTTON: View | Edit | Delete
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// VIEW
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.visibility,
                                color: Colors.blue),
                          ),

                          /// EDIT
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, color: Colors.orange),
                          ),

                          /// DELETE
                          IconButton(
                            onPressed: () {},
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
