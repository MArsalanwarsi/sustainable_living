import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class AdminForumListScreen extends StatefulWidget {
  const AdminForumListScreen({super.key});

  @override
  State<AdminForumListScreen> createState() => _AdminForumListScreenState();
}

class _AdminForumListScreenState extends State<AdminForumListScreen> {
  String selectedSort = 'Newest';
  String searchQuery = '';
  List<Map<String, dynamic>> posts = [
    {
      "type": "facebook",
      "id": "1",
      "name": "Saqib Ahmed",
      "avatar": "https://randomuser.me/api/portraits/men/11.jpg",
      "title": "How to reduce plastic at home?",
      "desc":
          "What are some practical ideas to reduce plastic usage, especially in the kitchen? Looking for actionable tips!",
      "image":
          "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=60",
      "category": "Recycling",
      "status": "Pending",
      "datetime": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "type": "instagram",
      "id": "2",
      "name": "Ali Khan",
      "avatar": "https://randomuser.me/api/portraits/men/80.jpg",
      "title": null,
      "desc":
          "Just started reducing my electricity bill – and it feels great! 💡⚡️",
      "image":
          "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=600&q=60",
      "category": "Energy Saving",
      "status": "Approved",
      "datetime": DateTime.now().subtract(const Duration(days: 1, minutes: 14)),
    },
    {
      "type": "facebook",
      "id": "3",
      "name": "Ayesha",
      "avatar": "https://randomuser.me/api/portraits/women/32.jpg",
      "title": "Is cycling better than walking?",
      "desc":
          "Which is more environmentally friendly and good for health: cycling or walking?",
      "image": null,
      "category": "Transport",
      "status": "Reported",
      "datetime": DateTime.now().subtract(const Duration(days: 3, hours: 2)),
    },
    {
      "type": "instagram",
      "id": "4",
      "name": "Annie",
      "avatar": "https://randomuser.me/api/portraits/women/85.jpg",
      "title": null,
      "desc":
          "Check out my recycled jars for pantry organisation! 🫙🌱 #EcoHacks",
      "image":
          "https://images.unsplash.com/photo-1520880867055-1e30d1cb001c?auto=format&fit=crop&w=600&q=60",
      "category": "Recycling",
      "status": "Approved",
      "datetime": DateTime.now().subtract(const Duration(hours: 5, minutes: 8)),
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    List<Map<String, dynamic>> results = posts.where((p) {
      final query = searchQuery.toLowerCase();
      return (p['title']?.toLowerCase().contains(query) ?? false) ||
          (p['desc']?.toLowerCase().contains(query) ?? false) ||
          (p['name']?.toLowerCase().contains(query) ?? false);
    }).toList();

    results.sort((a, b) {
      if (selectedSort == 'Newest') {
        return (b['datetime'] as DateTime).compareTo(a['datetime'] as DateTime);
      } else if (selectedSort == 'Oldest') {
        return (a['datetime'] as DateTime).compareTo(b['datetime'] as DateTime);
      } else if (selectedSort == 'A - Z') {
        String nameA = a['name']?.toString().toLowerCase() ?? '';
        String nameB = b['name']?.toString().toLowerCase() ?? '';
        return nameA.compareTo(nameB);
      } else if (selectedSort == 'Z - A') {
        String nameA = a['name']?.toString().toLowerCase() ?? '';
        String nameB = b['name']?.toString().toLowerCase() ?? '';
        return nameB.compareTo(nameA);
      }
      return 0;
    });
    return results;
  }

  Color get greenMain => const Color(0xFF448C2F);
  Color get greenDark => const Color(0xFF205907);
  Color get mintBackground => const Color(0xFFE6F3EA);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: mintBackground,
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context,3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // 🏷 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Forum Feed',
                    style: TextStyle(
                      color: greenDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.settings, color: greenDark),
                ],
              ),
              const SizedBox(height: 25),

              // ➕ Add New Feed Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenMain,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                      ),
                      onPressed: _showAddPostDialog,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add New Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 🔍 Search + Sort Row
              Row(
                children: [
                  // Search
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (query) {
                          setState(() => searchQuery = query);
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: greenDark),
                          hintText: 'Search posts...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Sort Dropdown
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSort,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: const [
                            DropdownMenuItem(
                              value: 'Newest',
                              child: Text('Newest'),
                            ),
                            DropdownMenuItem(
                              value: 'Oldest',
                              child: Text('Oldest'),
                            ),
                            DropdownMenuItem(
                              value: 'A - Z',
                              child: Text('A - Z'),
                            ),
                            DropdownMenuItem(
                              value: 'Z - A',
                              child: Text('Z - A'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedSort = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ListView.builder(
                itemCount: filteredPosts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return _FacebookPostCard(
                    avatarUrl: post['avatar'] ?? '',
                    name: post['name'] ?? 'Unknown',
                    title: post['title'] ?? '',
                    desc: post['desc'] ?? '',
                    imageUrl: post['image'],
                    category: post['category'] ?? '',
                    status: post['status'] ?? '',
                    datetime: post['datetime'] as DateTime,
                    onInfo: () => _showPostInfoDialog(post),
                    onEdit: () => _showEditPostDialog(post),
                    onDelete: () => _showDeleteConfirmationDialog(post),
                    greenDark: greenDark,
                  );
                },
              ),

              SizedBox(height: height * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  // Dialogs and Actions

  void _showAddPostDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Post"),
        content: const Text("Post creation UI coming soon..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showEditPostDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Post"),
        content: const Text("Edit post UI coming soon..."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Post"),
        content: Text(
          "Are you sure you want to delete this post by ${post["name"]}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                posts.removeWhere((e) => e['id'] == post['id']);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showPostInfoDialog(Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(post['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (post['title'] != null)
              Text(
                post['title'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (post['desc'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(post['desc']),
              ),
            if (post['category'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    const Icon(Icons.category, size: 18),
                    const SizedBox(width: 6),
                    Text(post['category']),
                  ],
                ),
              ),
            if (post['status'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18),
                    const SizedBox(width: 6),
                    Text("Status: ${post['status']}"),
                  ],
                ),
              ),
            if (post['datetime'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 6),
                    Text(post['datetime'].toString().substring(0, 16)),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

/// Facebook style post card
class _FacebookPostCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String title;
  final String desc;
  final String? imageUrl;
  final String category;
  final String status;
  final DateTime datetime;
  final VoidCallback onInfo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Color greenDark;

  const _FacebookPostCard({
    required this.avatarUrl,
    required this.name,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.category,
    required this.status,
    required this.datetime,
    required this.onInfo,
    required this.onEdit,
    required this.onDelete,
    required this.greenDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - avatar, name, time, action icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                  radius: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: greenDark,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${datetime.toLocal().toString().substring(0, 16)} • $category",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'info') onInfo();
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'info', child: Text("View")),
                    const PopupMenuItem(value: 'edit', child: Text("Edit")),
                    const PopupMenuItem(value: 'delete', child: Text("Delete")),
                  ],
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Title & description
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            if (desc.isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(desc, style: const TextStyle(fontSize: 14)),
            ],
            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 13),
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 170,
                ),
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
