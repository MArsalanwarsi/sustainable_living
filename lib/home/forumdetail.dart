import 'package:flutter/material.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Post Details"),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: _PostContent(),
        ),
      ),
      bottomNavigationBar: const _CommentInput(),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN POST CONTENT
// -----------------------------------------------------------------------------

class _PostContent extends StatelessWidget {
  const _PostContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PostHeader(),
        const SizedBox(height: 16),

        const Text(
          "Our New Solar Panel System is Up!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),
        const Text(
          "Thin the lmuat ande anl you thall alke, oaned to blsiee unton "
          "to phatr allp diw leet, or pontslop the iv slme thand sang to "
          "and festations.",
          style: TextStyle(fontSize: 15, height: 1.4),
        ),

        const SizedBox(height: 16),

        // IMAGE
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://cdn.pixabay.com/photo/2018/03/29/08/49/solar-3278825_1280.jpg",
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 12),

        // ONLY TOTALS
        const Text(
          "48 Likes • 12 Comments",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),

        const Divider(height: 32),

        const Text(
          "Comments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        // COMMENTS (MOCK)
        _CommentItem(
          name: "John D.",
          time: "1h ago",
          comment: "This is fantastic! What brand you go with?",
        ),
        _CommentItem(
          name: "John D.",
          time: "3h ago",
          comment: "This is Tesla Powerwall. Highly recommend!",
        ),
        _CommentItem(
          name: "EcoFanatic",
          time: "30m ago",
          comment: "We chose Tesla Powerwall. Highly recommend!",
          highlight: true,
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// POST HEADER
// -----------------------------------------------------------------------------

class _PostHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
            "https://randomuser.me/api/portraits/women/65.jpg",
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Sarah M.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("2h ago", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// COMMENT ITEM
// -----------------------------------------------------------------------------

class _CommentItem extends StatelessWidget {
  final String name;
  final String time;
  final String comment;
  final bool highlight;

  const _CommentItem({
    super.key,
    required this.name,
    required this.time,
    required this.comment,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlight ? Colors.green[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/men/32.jpg",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(comment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMMENT INPUT BAR
// -----------------------------------------------------------------------------

class _CommentInput extends StatelessWidget {
  const _CommentInput();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.green,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
