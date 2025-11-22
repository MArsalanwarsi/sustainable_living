import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustainable_living/Custom/customwidget.dart';
import 'forumdetail.dart';

class MainFeedScreen extends StatelessWidget {
  const MainFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),
      appBar: buildCustomAppBar(context),
      bottomNavigationBar: buildCustomBottomBar(context, 4),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Feeds')
              .orderBy('createdDate', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading feeds ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No approved forum posts available yet.'),
              );
            }
            final feeds = snapshot.data!.docs;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 26.0),
              itemCount: feeds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 19),
              itemBuilder: (context, idx) {
                final doc = feeds[idx];
                return _ForumCard(
                  id: doc.id,
                  title: (doc['title'] ?? '').toString(),
                  desc: (doc['description'] ?? '').toString(),
                  imageUrl: (doc['imageUrl'] ?? '').toString(),
                  status: (doc['status'] ?? '').toString(),
                  datetime: (doc['createdDate'] is Timestamp)
                      ? (doc['createdDate'] as Timestamp).toDate()
                      : DateTime.now(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailsPage(feedId: doc.id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ForumCard extends StatelessWidget {
  final String id;
  final String title;
  final String desc;
  final String? imageUrl;
  final String status;
  final DateTime datetime;
  final VoidCallback onTap;

  const _ForumCard({
    required this.id,
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.status,
    required this.datetime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors used in admin FacebookPostCard
    const Color greenDark = Color(0xFF205907);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - avatar, name, time
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: const AssetImage('assets/name.png'),
                    child: Container(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sustainable Living",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: greenDark,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          _formatDateTime(datetime),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // => NO 3-dot menu here!
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
                Text(
                  desc,
                  style: const TextStyle(fontSize: 14),
                ),
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
      ),
    );
  }

  static String _formatDateTime(DateTime dt) {
    // Format: yyyy-MM-dd HH:mm
    return "${dt.year.toString().padLeft(4, '0')}-"
           "${dt.month.toString().padLeft(2, '0')}-"
           "${dt.day.toString().padLeft(2, '0')} "
           "${dt.hour.toString().padLeft(2, '0')}:"
           "${dt.minute.toString().padLeft(2, '0')}";
  }
}
