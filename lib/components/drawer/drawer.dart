import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neighborgood/pages/misc/chatwithai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../pages/misc/aboutus.dart';

import '../../pages/dashboard/dashboard.dart';
import '../../pages/home/homepage.dart';
import '../../pages/misc/infopage.dart';
import '../../pages/home/landingpage.dart';
import '../../pages/login/loginscreen.dart';
import '../../pages/profiles/profile.dart';
import '../../pages/misc/services.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName = '';
  String _userImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? 'User';
      _userImageUrl = prefs.getString('picture') ?? '';
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all data from shared preferences
                prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pop();
                context.go(
                    '/login'); // Use GoRouter to navigate to the login screen
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset('assets/logolong.png'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          context.go('/dashboard');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dashboard_outlined, color: Colors.black),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Dashboard',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/profile');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.settings_outlined, color: Colors.black),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/about');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, color: Colors.black),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'About Us',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/about');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded,
                                color: Colors.black),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Payment History',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/services');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.groups_outlined, color: Colors.black),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'My Orders',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFE2E2E9), // Set button color to e59d14
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Rounded corners for button
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0), // Add button padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.headphones_outlined,
                      color: Colors.black,
                    ),
                    Text(
                      'Contact Support',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: _showLogoutDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
