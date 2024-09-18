import 'package:flutter/material.dart';
import 'package:neighborgood/components/drawer/drawer.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor =
        Colors.white; // White background for consistency
    const Color textColor = Colors.black; // Standard text color
    final Color accentColor = const Color(0xFFFF7800); // Orange accent color

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  const Color(0xFFf8a91b),
                  accentColor,
                ],
                stops: const [0.0, 1.0],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: const Text(
              "Information",
              style: TextStyle(
                fontFamily: 'poppinsbold',
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: textColor),
        ),
        drawer: AppDrawer(),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Welcome to NeighborGood!",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "At NeighborGood, we aim to connect neighborhoods and build a stronger community through shared experiences. Whether you're organizing a neighborhood event, looking to meet new people, or seeking help from your community, we're here to help you get started.",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/community.png',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Our Mission",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We believe that a connected neighborhood is a happier, safer, and more vibrant place to live. Our platform is designed to make it easy for you to connect with your neighbors, discover local events, and get involved in your community.",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Join Us",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Ready to join the community? Whether you're new to the neighborhood or a long-time resident, we invite you to explore the features of NeighborGood and see how you can contribute to a stronger, more connected community.",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Action on button press
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
