import 'package:flutter/material.dart';
import 'package:neighborgood/components/drawer/drawer.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool isDarkTheme = true;
  List<bool> isExpandedList = [false, false, false, false];

  void toggleTheme(bool value) {
    setState(() {
      isDarkTheme = value;
    });
  }

  void toggleExpand(int index) {
    setState(() {
      isExpandedList[index] = !isExpandedList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isDarkTheme ? Colors.black : Colors.white;
    Color textColor = isDarkTheme ? Colors.white : Colors.black;
    Color stacktextColor = isDarkTheme ? const Color(0xFFf7e1d0) : Colors.black;
    Color appBarColor = isDarkTheme ? Colors.black : Colors.white;
    Color lightText = isDarkTheme ? const Color(0xFFf7e1d0) : Colors.black;
    Color stackColor =
        isDarkTheme ? const Color(0xFF1e293b) : const Color(0xFFf1f5f9);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Row(
            children: [
              Text(
                "Our ",
                style: TextStyle(
                  fontFamily: 'poppinsbold',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: lightText,
                ),
              ),
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
                  "Services",
                  style: TextStyle(
                    fontFamily: 'poppinsbold',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkTheme
                  ? [const Color(0xFF1c1c1c), const Color(0xFF363636)]
                  : [const Color(0xFFf8f8f8), const Color(0xFFe0e0e0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: stackColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            'assets/stack1.png',
                            height: 150.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Connect, Discover, Attend: Meet Your Neighbors!",
                          style: TextStyle(
                            fontFamily: 'poppinsbold',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: stacktextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => toggleExpand(index),
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                            ),
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return const Color(
                                      0xFFFF5400); // Darker on press
                                }
                                return const Color(0xFFFF7800); // Primary color
                              },
                            ),
                          ),
                          child: Icon(
                            isExpandedList[index]
                                ? Icons.arrow_circle_up_sharp
                                : Icons.arrow_circle_down_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        if (isExpandedList[index])
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                'Find your perfect match based on shared interests and hobbies, with our interest matching service — because compatibility goes beyond looks!',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontSize: 16.0,
                                  color: textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
