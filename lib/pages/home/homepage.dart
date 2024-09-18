import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neighborgood/pages/misc/chatwithai.dart';
import 'package:neighborgood/components/drawer/drawer.dart';
import 'package:neighborgood/pages/login/form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Neighborgood",
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xffE49C17),
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text('Select Your Preferred Way to Share Interests',
                  style: TextStyle(
                      color: Color(0xffE49C17),
                      fontSize: 20,
                      fontFamily: 'poppinsbold')),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  "Everyone's different, and so is the way we like to share. Choose the method that feels right for you to tell us about your interests. Whether you prefer a straightforward form or an interactive chat with our AI",
                  style: TextStyle(
                      color: Color(0xffA4A4A4),
                      fontSize: 15,
                      fontFamily: 'poppins')),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MultiStepForm()),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust border radius for boxy shape
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0), // Adjust padding
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFFFF7800); // Color on hover
                        }
                        return const Color(0xFFFFAF00); // Default color
                      },
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.interests_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        "Interests Form",
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontFamily: 'poppinsbold',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VoiceflowWidget()),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust border radius for boxy shape
                      ),
                    ),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0), // Adjust padding
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xFFFF7800);
                        }
                        return const Color(0xFFFFAF00);
                      },
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ImageIcon(
                        AssetImage('assets/Vector.png'),
                        color: Colors.white,
                      ),
                      Text(
                        "A.I ChatBot",
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontFamily: 'poppinsbold',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
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
    ));
  }
}
