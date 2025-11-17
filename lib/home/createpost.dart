import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String selectedCategory = "General";

  final List<String> postCategories = [
    "General",
    "Tips",
    "Recycling",
    "Lifestyle",
    "Energy Saving",
    "Water Saving",
    "Questions",
  ];

  double responsiveFont(BuildContext context, double size) {
    double scale = MediaQuery.of(context).size.width / 390; // Base iPhone 12 width
    return size * scale.clamp(0.8, 1.3); // Prevent too small or too large text
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC3FFAB), Color(0xFFE8F5E9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Post",
                              style: TextStyle(
                                color: green,
                                fontWeight: FontWeight.w600,
                                fontSize: responsiveFont(context, 15),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Create Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsiveFont(context, 22),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // USER INFO
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Muhammad Saqib Ahmed",
                                    style: TextStyle(
                                      fontSize: responsiveFont(context, 16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    softWrap: true,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Share your thoughts with the community.",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: responsiveFont(context, 13),
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // DESCRIPTION BOX
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextField(
                          maxLines: 4,
                          style: TextStyle(fontSize: responsiveFont(context, 15)),
                          decoration: InputDecoration(
                            hintText: "What's on your eco mind?",
                            hintStyle:
                                TextStyle(fontSize: responsiveFont(context, 15)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CATEGORY DROPDOWN
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down, color: green),
                          items: postCategories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                style: TextStyle(
                                    fontSize: responsiveFont(context, 15)),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => selectedCategory = value!);
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ONLY ADD PHOTO BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildActionButton(
                            icon: Icons.camera_alt,
                            label: "Add Photo",
                            fontSize: responsiveFont(context, 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // IMAGE PREVIEW
                      Center(
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.green, width: 1.5),
                            image: const DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1501004318641-b39e6451bec6",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // POST BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            "Post Now",
                            style: TextStyle(
                              fontSize: responsiveFont(context, 18),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Responsive Action Button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required double fontSize,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.green, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
