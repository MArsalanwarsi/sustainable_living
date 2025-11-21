import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustainable_living/Custom/admincustomwidget.dart';

class AdminTipsListScreen extends StatefulWidget {
  const AdminTipsListScreen({super.key});

  @override
  State<AdminTipsListScreen> createState() => _AdminTipsListScreenState();
}

class _AdminTipsListScreenState extends State<AdminTipsListScreen> {
  String selectedSort = "Newest";
  String search = '';

  // Controllers for add/edit dialogs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // For edit state tracking
  String? editingTipId;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _showTipDialog({DocumentSnapshot? existingTip}) {
    if (existingTip != null) {
      _titleController.text = existingTip['title'];
      _descController.text = existingTip['description'];
      editingTipId = existingTip.id;
    } else {
      _titleController.clear();
      _descController.clear();
      editingTipId = null;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingTip == null ? 'Add Eco Tip' : 'Edit Eco Tip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
            ),
            onPressed: () async {
              String title = _titleController.text.trim();
              String desc = _descController.text.trim();
              if (title.isEmpty || desc.isEmpty) return;

              if (editingTipId == null) {
                // Add
                await FirebaseFirestore.instance.collection('Tips').add({
                  'title': title,
                  'description': desc,
                  'created': Timestamp.now(),
                });
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Eco Tip added!')));
              } else {
                // Edit
                await FirebaseFirestore.instance
                    .collection('Tips')
                    .doc(editingTipId)
                    .update({
                      'title': title,
                      'description': desc,
                      // 'created' left as original -- don't update timestamp on edit
                    });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Eco Tip updated!')),
                );
              }

              if (mounted) Navigator.pop(ctx);
            },
            child: Text(existingTip == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteTip(String id, String title) async {
    await FirebaseFirestore.instance.collection('Tips').doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Deleted '$title'")));
  }

  @override
  Widget build(BuildContext context) {
    Query tipQuery = FirebaseFirestore.instance.collection('Tips');

    // Search filter
    if (search.trim().isNotEmpty) {
      tipQuery = tipQuery
          .where('title', isGreaterThanOrEqualTo: search)
          .where('title', isLessThanOrEqualTo: '${search}\uf8ff');
    }

    // Sorting
    switch (selectedSort) {
      case "Newest":
        tipQuery = tipQuery.orderBy('created', descending: true);
        break;
      case "Oldest":
        tipQuery = tipQuery.orderBy('created', descending: false);
        break;
      case "Category A-Z":
        tipQuery = tipQuery.orderBy('title', descending: false);
        break;
      case "Category Z-A":
        tipQuery = tipQuery.orderBy('title', descending: true);
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE6F3EA),
      appBar: buildAdminCustomAppBar(context),
      bottomNavigationBar: buildAdminCustomBottomBar(context, 4),

      // Only "+" FAB; white icon.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTipDialog(),
        backgroundColor: Colors.green.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
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
                  hintText: "Search eco tips...",
                ),
                onChanged: (v) => setState(() => search = v),
              ),
            ),
            const SizedBox(height: 14),
            // Sort Dropdown
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
                    child: DropdownButton<String>(
                      value: selectedSort,
                      items:
                          ["Newest", "Oldest", "Category A-Z", "Category Z-A"]
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedSort = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // The Eco Tips List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tipQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No eco tips found.'));
                  }
                  final tips = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: tips.length,
                    itemBuilder: (context, index) {
                      final tipDoc = tips[index];
                      final tipData = tipDoc.data() as Map<String, dynamic>;
                      final Timestamp? createdTs =
                          tipData['created'] as Timestamp?;
                      final createdDate = createdTs != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                              createdTs.millisecondsSinceEpoch,
                            )
                          : null;

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
                                // Tip Icon
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: Colors.green.shade100,
                                  child: Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Colors.green.shade700,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Title + Description + Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tipData["title"] ?? '',
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        tipData["description"] ?? '',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        createdDate != null
                                            ? "Added: ${createdDate.year}-${createdDate.month.toString().padLeft(2, '0')}-${createdDate.day.toString().padLeft(2, '0')}"
                                            : "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // ACTION BUTTONS → Edit | Delete
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // EDIT
                                IconButton(
                                  onPressed: () {
                                    _showTipDialog(existingTip: tipDoc);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  tooltip: 'Edit',
                                ),
                                // DELETE
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Delete Eco Tip?'),
                                        content: Text(
                                          "Are you sure you want to delete \"${tipData["title"] ?? ''}\"?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade700,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _deleteTip(
                                                tipDoc.id,
                                                tipData["title"] ?? '',
                                              );
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
