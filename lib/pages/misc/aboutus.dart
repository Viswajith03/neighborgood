import 'package:flutter/material.dart';
import 'package:neighborgood/components/drawer/drawer.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    // Define your primary colors and theme styles
    final Color primaryColor =
        const Color(0xFFFF7800); // Orange color for emphasis
    const Color textColor = Colors.black; // Black text on white background
    const Color backgroundColor =
        Colors.white; // White background for clean layout

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor), // Dark icon colors
          title: Row(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color(0xFFf8a91b),
                      Color(0xFFFF5400),
                    ],
                    stops: [0.0, 1.0],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: const Text(
                  "About ",
                  style: TextStyle(
                    fontFamily: 'poppinsbold',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "Us",
                style: TextStyle(
                  fontFamily: 'poppinsbold',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor, // Orange text for emphasis
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "NeighborGood is on a mission to provide the simplest platform for neighborhoods to form connections & community. We are going after this by creating an AI agent that acts as the highly-social extrovert neighbor who finds symbiotic activities for people to do together.",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontFamily: 'poppins',
                  height: 1.5, // Increase line height for readability
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/about.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "We offer users the ability to screen potential nearby connections and arrange shared face-to-face activities. Our team previously founded Foresight Institute, Persist Ventures, & Systemic Altruism.",
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontFamily: 'poppins',
                  height: 1.5, // Increase line height for readability
                ),
              ),
              const SizedBox(height: 30), // Add more spacing for visual relief
            ],
          ),
        ),
      ),
    );
  }
}
