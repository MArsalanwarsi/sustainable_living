import 'package:flutter/material.dart';
import 'package:sustainable_living/Custom/customwidget.dart';

class MainFeedScreen extends StatelessWidget {
  const MainFeedScreen({super.key});

  // Dummy feed data
  static final List<FeedItem> feeds = [
    FeedItem(
      image: 'assets/solar.png',
      title: 'Solar Panels for Clean Energy',
      description: 'Discover how rooftop solar panels help reduce carbon footprint and power homes with renewable energy.',
      detail: 'Solar panels are a sustainable solution for generating clean, renewable energy right on your rooftop. Besides reducing electricity bills, they contribute significantly to cutting down fossil fuel usage, lowering overall emissions, and forging a path toward a greener future.',
    ),
    FeedItem(
      image: 'assets/bottle.png',
      title: 'Switching to Bamboo Bottles',
      description: "An eco-friendly alternative to plastic bottles, bamboo reduces waste and keeps drinks fresh.",
      detail: "Bamboo bottles are biodegradable, reusable, and naturally antimicrobial. Making the switch not only benefits your health but also contributes to a circular economy by curbing single-use plastics.",
    ),
    FeedItem(
      image: 'assets/bin.png',
      title: 'Composting for Greener Gardens',
      description: "Composting kitchen waste is easy and rewarding. Convert scraps to gold for your plants.",
      detail: "Composting diverts food waste from landfills and creates nutrient-rich soil for gardening. Even apartment dwellers can start composting with simple bins, reaping environmental and personal benefits.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),
      appBar: buildCustomAppBar(context),
      bottomNavigationBar: buildCustomBottomBar(context,4),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 22),
          itemCount: feeds.length,
          separatorBuilder: (context, idx) => const SizedBox(height: 19),
          itemBuilder: (context, idx) {
            final feed = feeds[idx];
            return _FeedPostCard(
              feed: feed,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FeedDetailScreen(feed: feed),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FeedItem {
  final String image;
  final String title;
  final String description;
  final String detail;
  const FeedItem({
    required this.image,
    required this.title,
    required this.description,
    required this.detail,
  });
}

class _FeedPostCard extends StatelessWidget {
  final FeedItem feed;
  final VoidCallback? onTap;

  const _FeedPostCard({
    required this.feed,
    this.onTap,
  });

  String getShortDescription(String desc, {int maxChars = 95}) {
    if (desc.length <= maxChars) return desc;
    int lastSpace = desc.substring(0, maxChars).lastIndexOf(' ');
    if (lastSpace < 0) lastSpace = maxChars;
    return desc.substring(0, lastSpace).trim() + '...';
  }

  @override
  Widget build(BuildContext context) {
    // Responsive width for shadow design
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFE5EEE9),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image on top, with subtle overlay for visual depth
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Image.asset(
                    feed.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(19),
                        bottomRight: Radius.circular(19),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.23),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content area: title, description + arrow
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 17, 17, 13),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feed.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17.8,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.12,
                            color: Color(0xff12933d), // deep eco green
                            height: 1.13,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          getShortDescription(feed.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.32,
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.01,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  // trailing arrow
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onTap,
                      child: Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xffe9f6ee),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff12933d),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedDetailScreen extends StatelessWidget {
  final FeedItem feed;
  const FeedDetailScreen({Key? key, required this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Market-style, clean and modern detail page
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          feed.title,
          style: const TextStyle(
            color: Color(0xff12933d),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.1,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xff12933d)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.asset(
                feed.image,
                width: double.infinity,
                height: 235,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feed.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff12933d),
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 21),
                  Text(
                    feed.detail,
                    style: const TextStyle(
                      fontSize: 17.1,
                      color: Color(0xff333d38),
                      height: 1.61,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
