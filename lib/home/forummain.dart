import 'package:flutter/material.dart';

class MainFeedScreen extends StatelessWidget {
  const MainFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// -------------------------
              /// TOP "What's on your eco mind?"
              /// -------------------------
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage("assets/user1.png"),
                    ),
                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "What’s on your eco mind?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Row(
                      children: const [
                        Icon(Icons.image_outlined,
                            color: Colors.green, size: 26),
                        SizedBox(width: 12),
                        Icon(Icons.video_camera_back_outlined,
                            color: Colors.green, size: 26),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// -----------------------------------------
              /// POST 1 — Solar Panel Post
              /// -----------------------------------------
              const PostCard(
                avatar: "assets/user1.png",
                username: "EcoWarrior45",
                timeAgo: "5m ago",
                text:
                    "Just installed panels on my roof! So excited So generate own clean energy. #SolarPower",
                image: "assets/solar.png",
              ),

              const SizedBox(height: 20),

              /// -----------------------------------------
              /// POST 2 — Water Bottle Post
              /// -----------------------------------------
              const PostCard(
                avatar: "assets/user2.png",
                username: "GreenGuru88",
                timeAgo: "1h ago",
                text:
                    "Baambbow water bottle it is you bombo ఝంbamboo botle",
                image: "assets/bottle.png",
              ),

              const SizedBox(height: 20),

              /// -----------------------------------------
              /// POST 3 — Compost Post
              /// -----------------------------------------
              const PostCard(
                avatar: "assets/user3.png",
                username: "CompostQueen",
                timeAgo: "3h ago",
                text:
                    "And fheert as bias a cenrsded comp fou your stily re sporich inue despstong.",
                image: "assets/bin.png",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String avatar;
  final String username;
  final String timeAgo;
  final String text;
  final String? image;

  const PostCard({
    super.key,
    required this.avatar,
    required this.username,
    required this.timeAgo,
    required this.text,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(avatar),
              ),
              const SizedBox(width: 10),

              /// USERNAME + TIME
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff008037), // nice eco green
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TEXT
          Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 10),

          /// IMAGE (optional)
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),

          const SizedBox(height: 10),

          /// ACTION BUTTONS
          Row(
            children: const [
              _ActionButton(icon: Icons.favorite_border, label: "Like"),
              SizedBox(width: 20),
              _ActionButton(icon: Icons.comment_outlined, label: "Comment"),
              SizedBox(width: 20),
              _ActionButton(icon: Icons.share_outlined, label: "Share"),
            ],
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xff008037), size: 20),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff008037),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
