import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsPage extends StatelessWidget {
  final String feedId;
  const PostDetailsPage({required this.feedId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Post Details"), centerTitle: true),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Feeds')
              .doc(feedId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("Post not found."));
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _PostContent(
                createdDate: data['createdDate'],
                title: data['title'] ?? '',
                description: data['description'] ?? '',
                imageUrl: data['imageUrl'],
                status: data['status'] ?? '',
              ),
            );
          },
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN POST CONTENT
// -----------------------------------------------------------------------------

class _PostContent extends StatelessWidget {
  final dynamic createdDate; // Timestamp or null
  final String title;
  final String description;
  final String? imageUrl;
  final String status;

  const _PostContent({
    Key? key,
    this.createdDate,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
  }) : super(key: key);

  String formatDate(dynamic ts) {
    if (ts == null) return '';
    final dt = ts is Timestamp ? ts.toDate() : (ts is DateTime ? ts : null);
    if (dt == null) return '';
    // Example: 22 Nov 2025, 02:32 AM (UTC+5)
    return "${dt.day.toString().padLeft(2, '0')} "
        "${_monthName(dt.month)} "
        "${dt.year}, "
        "${_two(dt.hour)}:${_two(dt.minute)} "
        "${dt.hour < 12 ? 'AM' : 'PM'} "
        "UTC${_formatTimeZoneOffset(dt.timeZoneOffset)}";
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
  static String _monthName(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return (m > 0 && m < 13) ? months[m] : '';
  }

  static String _formatTimeZoneOffset(Duration offset) {
    if (offset.inMinutes == 0) return '';
    final sign = offset.isNegative ? '-' : '+';
    final h = offset.inHours.abs();
    final m = (offset.inMinutes.abs() % 60);
    if (m == 0) {
      return '$sign$h';
    }
    return '$sign$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // No author/avatar section, as those fields are not present
        if (createdDate != null)
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                formatDate(createdDate),
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        if (createdDate != null) const SizedBox(height: 14),

        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),
        Text(description, style: const TextStyle(fontSize: 15, height: 1.4)),

        if (imageUrl != null && imageUrl!.isNotEmpty) ...[
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) => Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image, size: 70, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 20),

        Row(
          children: [
            const Text(
              "Status:",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == "Approved" ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),

        const SizedBox(height: 25),
      ],
    );
  }
}
