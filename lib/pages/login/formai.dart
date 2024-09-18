import 'package:flutter/material.dart';
import 'package:neighborgood/pages/login/form.dart';

class ChooseForm extends StatefulWidget {
  const ChooseForm({super.key});

  @override
  State<ChooseForm> createState() => _ChooseFormState();
}

class _ChooseFormState extends State<ChooseForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fill Your Preference",
          style: TextStyle(fontFamily: 'poppins'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select your Preferred way to share Interests',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Everyone's unique, and so is how we like to share.",
                style: TextStyle(
                  fontFamily: 'poppins',
                  color: Color(0xffFF7800),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Text(
                "Choose the method that suits you best to tell us about your interests.",
                style: TextStyle(fontFamily: 'poppins'),
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset(
              'assets/form.png',
              height: 200,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // Set width to avoid overflow
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiStepForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                          color: Colors.black), // Add black border
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFFFF7800); // Color on hover
                      }
                      return const Color(0xFF767676); // Default color
                    },
                  ),
                ),
                child: const Text(
                  "Fill The Interest Form",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'poppinsbold',
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/bot.png',
              height: 200, // Set height as needed
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.8, // Set width to avoid overflow
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiStepForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(
                          color: Colors.black), // Add black border
                    ),
                  ),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFFFF7800); // Color on hover
                      }
                      return const Color(0xFF767676); // Default color
                    },
                  ),
                ),
                child: const Text(
                  "Use AI ChatBot",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'poppinsbold',
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50), // Add space after the buttons
          ],
        ),
      ),
    );
  }
}
