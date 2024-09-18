import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neighborgood/pages/login/registerscreen.dart';
import 'package:neighborgood/components/navbar/navbar.dart';
import 'package:neighborgood/api/google_signin_api.dart';
import 'package:neighborgood/components/constants.dart';
import '../dashboard/dashboard.dart'; // Import the dashboard

import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Function to handle login
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${Constants.apiUrl}/login/'); // Backend URL
    final body = json.encode({
      'email': _email,
      'password': _password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Login successful') {
          // Save user session or token in SharedPreferences if needed
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseData['token']);

          // Navigate to the dashboard screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()),
          );
        } else {
          Fluttertoast.showToast(
              msg: responseData['message']); // Informative error
        }
      } else {
        Fluttertoast.showToast(
            msg:
                'Login failed (code: ${response.statusCode})'); // More specific error
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'An error occurred: $error');
      // Consider checking for specific network errors using the 'connectivity' package
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> signIn() async {
    final user = await GoogleSignInApi.login();

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DashBoardScreen(),
      ));
    } else {
      Fluttertoast.showToast(msg: 'Google sign-in failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The ShaderMask containing the slanted image grid at the top
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
                height: 350, // Height for the image area
                child: Stack(
                  children: [
                    Positioned(
                      left: -314,
                      top: -114,
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
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                        height: 30), // Space between the image grid and form
                    _buildWelcomeText(),
                    const SizedBox(height: 20),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    _buildRememberForgotRow(),
                    const SizedBox(height: 20),
                    _buildSignInButton(),
                    const SizedBox(height: 20),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildGoogleLoginButton(),
                    const SizedBox(height: 20),
                    _buildRegisterText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(String assetPath, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 120, // Same as the LandingPage
        height: 120, // Same as the LandingPage
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Hi, Welcome Back! 👋',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Hello again you’ve been missed!',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
        hintText: 'Enter your email address',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) {
        _email = value!;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
        hintText: 'Enter your Password',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(12.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (bool? value) {
                // Handle remember me
              },
            ),
            const Text(
              'Remember Me',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black54,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
            );
          },
          child: const Text(
            'Forgot Password',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xffFF7800),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        _isLoading ? 'Loading...' : 'Log In',
        style: const TextStyle(
          fontSize: 16.0,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return OutlinedButton.icon(
      onPressed: signIn,
      icon: Image.asset('assets/google_logo.png', height: 24),
      label: const Text(
        'Google',
        style: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Poppins',
          color: Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'Or Login With',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildRegisterText() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
          );
        },
        child: const Text(
          'Don’t have an account? Register',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xffFF7800),
          ),
        ),
      ),
    );
  }
}
