import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neighborgood/pages/home/homepage.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:neighborgood/components/constants.dart';

class RegisterScreenTwo extends StatefulWidget {
  final VoidCallback? onNext;

  const RegisterScreenTwo({super.key, this.onNext});

  @override
  _RegisterScreenTwoState createState() => _RegisterScreenTwoState();
}

class _RegisterScreenTwoState extends State<RegisterScreenTwo> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String email =
      "neighborgood@gmail.com"; //TODO: This should be passed or fetched
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildStepIndicator(),
            Column(
              children: [
                _headingText(),
                const SizedBox(height: 20),
                _subheadingText(),
                const SizedBox(height: 20),
                _mailText(),
              ],
            ),
            _pinInputForm(),
            if (isLoading) const CircularProgressIndicator(),
            _resendCodeLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return FlutterStepIndicator(
      height: 20,
      disableAutoScroll: false,
      list: const ['Personal Details', 'Verification', 'Completion'],
      onChange: (int index) {},
      page: currentStep,
      positiveColor: Colors.orange,
      negativeColor: Colors.grey,
      progressColor: Colors.orange,
    );
  }

  Widget _headingText() {
    return const Text(
      "Verification",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 25,
      ),
    );
  }

  Widget _subheadingText() {
    return const Text(
      "Enter the code sent to the mail",
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  Widget _mailText() {
    return Text(
      email,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    );
  }

  Widget _resendCodeLink() {
    return TextButton(
      onPressed: _showDummyResendMessage,
      child: const Text(
        "Didn't get the code? Resend Code",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.orange,
        ),
      ),
    );
  }

  void _showDummyResendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resend OTP functionality is currently unavailable.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _pinInputForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Pinput(
            length: 4, // Specify the length of the OTP
            validator: (value) {
              return value != null && value.length == 4
                  ? null
                  : "Please enter a 4-digit code";
            },
            onCompleted: (pin) {
              if (formKey.currentState!.validate()) {
                _verifyPin(pin);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Get the current pin value from Pinput
                final currentPin =
                    formKey.currentState!._fields['pinput']?.value;
                if (currentPin != null) {
                  _verifyPin(currentPin);
                }
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPin(String pin) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Constants.apiUrl}/verify_otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': pin}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isVerified', true);
        await prefs.setString('jwt_token', data['token']);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect verification code.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

extension on FormState {
  get _fields => null;
}
