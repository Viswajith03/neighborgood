import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../components/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _success = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse(
              "${Constants.apiUrl}/forgot_password/"), // Replace with your API endpoint
          body: json.encode({'email': _emailController.text}),
          headers: {'Content-Type': 'application/json'},
        );

        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: responseData['message']);
          setState(() {
            _success = true;
          });
        } else {
          throw Exception(responseData['message']);
        }
      } catch (error) {
        Fluttertoast.showToast(msg: 'Error: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildHeaderImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoundedImage("assets/user1.jpg"),
        _buildRoundedImage("assets/user2.jpg"),
        _buildRoundedImage("assets/user3.jpg"),
        _buildRoundedImage("assets/user4.jpg"),
        _buildRoundedImage("assets/user5.jpg"),
      ],
    );
  }

  Widget _buildRoundedImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage(assetPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                _buildHeaderImages(),
                const SizedBox(height: 30),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address to receive a password reset link.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(
                        fontFamily: 'poppins', color: Colors.black),
                    hintText: 'Enter your email address',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
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
                    if (value == null ||
                        value.isEmpty ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'poppins'),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Send Reset Email',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                ),
                if (_success)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Email sent, please check your mail.',
                      style:
                          TextStyle(color: Colors.green, fontFamily: 'poppins'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigates back to the previous screen (Login)
                  },
                  child: const Text(
                    'Return to Login',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      color: Color(0xffFF7800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
