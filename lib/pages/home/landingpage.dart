import 'package:flutter/material.dart';

import 'package:neighborgood/pages/login/loginscreen.dart';
import 'package:neighborgood/pages/login/registerscreen.dart';

import '../card/card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Function to create an opacity-based image container
  Widget _buildImageContainer(String assetPath, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 120, // Increased width
        height: 120, // Increased height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Adjusted border radius
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8, // Increased blur radius for a softer shadow
              offset: const Offset(
                  0, 8), // Increased offset for a more pronounced shadow
            ),
          ],
        ),
      ),
    );
  }

  // Custom button widget
  Widget _buildCustomButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.8, // Button width as 80% of screen width
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2c2c2c), // Button color
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Slightly more rounded corners
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 18.0), // Increased vertical padding
          shadowColor: Colors.black.withOpacity(0.3), // Softer shadow color
          elevation:
              12, // Increased elevation for a more prominent shadow effect
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0, // Slightly larger font for better readability
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.transparent],
                  stops: [0.7, 1.0],
                ).createShader(bounds);
              },
              child: SizedBox(
                width: double.infinity,
                height: 350, // Increased height for the shader mask area
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 888, // Adjusted top position to fit your design
                      child: Container(
                        width: 108,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF1D1B20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -314, // Adjusted left position to fit your design
                      top: -114, // Adjusted top position to fit your design
                      child: SizedBox(
                        width: 932.49,
                        height: 1024,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 144,
                              top: 0,
                              child: Opacity(
                                opacity: 0.75,
                                child: SizedBox(
                                  width: 788.49,
                                  height: 488.49,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 359.78,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(-0.79),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  _buildImageContainer(
                                                      "assets/user1.jpg", 0.50),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user2.jpg", 0.75),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user3.jpg", 0.80),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user4.jpg", 0.80),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  _buildImageContainer(
                                                      "assets/user5.jpg", 0.60),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user6.jpg", 0.70),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user7.jpg", 0.85),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user8.jpg", 0.90),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user9.jpg", 0.55),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  _buildImageContainer(
                                                      "assets/user9.jpg", 0.55),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user1.jpg", 0.65),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user2.jpg", 0.75),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user3.jpg", 0.85),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user3.jpg", 0.80),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  _buildImageContainer(
                                                      "assets/user4.jpg", 0.70),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user5.jpg", 0.80),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user6.jpg", 0.90),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user7.jpg", 0.95),
                                                ],
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  _buildImageContainer(
                                                      "assets/user8.jpg", 0.60),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user9.jpg", 0.70),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user1.jpg", 0.80),
                                                  const SizedBox(width: 16),
                                                  _buildImageContainer(
                                                      "assets/user2.jpg", 0.90),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child:
                        Image.asset('assets/logolong.png'), // Increased height
                  ),
                  const Text(
                    'Welcome To The Neighborgood App!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Bolder font for emphasis
                      fontSize: 18.0, // Slightly larger text
                    ),
                  ),
                  const SizedBox(height: 30), // Adjust spacing as needed
                  _buildCustomButton(context, 'Login', LoginScreen()),
                  const SizedBox(height: 30), // Adjust spacing as needed
                  _buildCustomButton(
                      context, 'Register', const RegisterScreen()),
                  const SizedBox(height: 20),
                  _buildCustomButton(
                      context, 'Send A Postcard', PostcardPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
