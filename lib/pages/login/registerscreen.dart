import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:neighborgood/pages/login/registerscreentwo.dart';
import 'package:neighborgood/pages/login/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  int _currentStep = 0;

  static const List<String> _steps = [
    'Personal Details',
    'Verification',
    'Completion'
  ];

  @override
  void dispose() {
    [
      _nameController,
      _emailController,
      _passwordController,
      _confirmPasswordController
    ].forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://neighborgood.io/api/index/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'source': 'app',
        }),
      );

      if (response.statusCode == 201) {
        _navigateToNextPage();
      } else {
        _showMessage(
            jsonDecode(response.body)['message'] ?? 'An error occurred');
      }
    } catch (error) {
      _showMessage('An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToNextPage() {
    // Using Navigator to push the next page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegisterScreenTwo(),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _buildStepIndicator(),
                  const SizedBox(height: 30),
                  _buildTitleText(),
                  const SizedBox(height: 20),
                  _buildTextField(_nameController, 'Name', 'Enter your name'),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _emailController, 'Email', 'Enter your email address',
                      isEmail: true),
                  const SizedBox(height: 20),
                  _buildTextField(
                      _passwordController, 'Password', 'Enter your Password',
                      isPassword: true),
                  const SizedBox(height: 20),
                  _buildTextField(_confirmPasswordController,
                      'Confirm Password', 'Confirm your Password',
                      isPassword: true, isConfirmPassword: true),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                  _buildLoginText(), // Add the login button here
                ],
              ),
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return FlutterStepIndicator(
      height: 20,
      disableAutoScroll: false,
      list: _steps,
      onChange: (index) => setState(() => _currentStep = index),
      page: _currentStep,
      positiveColor: Colors.orange,
      negativeColor: Colors.grey,
      progressColor: Colors.orange,
    );
  }

  Widget _buildTitleText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Register to connect with your',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'poppins'),
        ),
        SizedBox(height: 4),
        Text(
          'Neighborhood',
          style: TextStyle(
              fontSize: 24, color: Color(0xFFFF7F00), fontFamily: 'poppins'),
        ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool isEmail = false,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'poppins', color: Colors.black),
        hintText: hint,
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
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'This field is required.';
        if (isEmail && !value!.contains('@'))
          return 'Please enter a valid email address.';
        if (isPassword && value!.length < 6)
          return 'Password must be at least 6 characters long.';
        if (isConfirmPassword && value != _passwordController.text)
          return 'Passwords do not match.';
        return null;
      },
      style: const TextStyle(color: Colors.black, fontFamily: 'poppins'),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _register,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        _isLoading ? 'Loading...' : 'Submit',
        style: const TextStyle(
            fontSize: 16.0, fontFamily: 'Poppins', color: Colors.white),
      ),
    );
  }

  Widget _buildLoginText() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        child: Text(
          'Already have an account? Login',
          style: TextStyle(
            fontFamily: 'poppins',
            color: Color(0xffFF7800),
          ),
        ),
      ),
    );
  }
}
