import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neighborgood/pages/profiles/addinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../components/constants.dart'; // Assuming you have a constants file with your API URL
import '../home/homepage.dart'; // Assuming you have a HomePage widget

class Verify extends StatefulWidget {
  final VoidCallback? onNext; // Callback to navigate to the next step
  final VoidCallback? onPrevious; // Callback to navigate to the previous step

  const Verify({super.key, this.onNext, this.onPrevious});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  int _timeLeft = 10;
  bool _isButtonDisabled = true;
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode()); // Focus nodes for OTP fields

  @override
  void initState() {
    super.initState();
    _checkUserConfirmation();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _checkUserConfirmation() async {
    final token = await _getToken();

    if (token != null) {
      final url = Uri.parse('${Constants.apiUrl}/check_confirmation/');
      final headers = {'Authorization': 'Bearer $token'};
      final body = json.encode({'token': token});

      try {
        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['email_confirmed']) {
            // Execute onNext callback to navigate to the next step
            if (widget.onNext != null) {
              widget.onNext!();
            }
          }
        } else {
          print('Error checking confirmation: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    } else {
      print('No token found in storage');
    }
  }

  Future<void> _handleResend() async {
    final token = await _getToken();

    if (token != null) {
      final url = Uri.parse('${Constants.apiUrl}/resend_confirmation/');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };
      final body = json.encode({'token': token});

      try {
        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          Toast.show(data['message'],
              duration: Toast.lengthShort, gravity: Toast.center);
          setState(() {
            _isButtonDisabled = true;
            _timeLeft = 120;
          });
          _startCountdown();
        } else {
          final message = response.reasonPhrase ?? 'Unknown error';
          Toast.show(message,
              duration: Toast.lengthShort, gravity: Toast.center);
        }
      } catch (error) {
        print('Error resending confirmation: $error');
        Toast.show('Error resending confirmation',
            duration: Toast.lengthShort, gravity: Toast.center);
      }
    } else {
      print('No token found in storage');
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isButtonDisabled = false;
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    // Clear the next field if current field is filled
    if (value.isNotEmpty && index < _controllers.length - 1) {
      _controllers[index + 1].text = '';
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    // Move focus to the previous field if current field is cleared
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    // Limit input to single characters
    if (value.length > 1) {
      _controllers[index].text = value.substring(0, 1);
    }

    // Check if all OTP fields are filled
    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
      // All fields have been filled
      // You can proceed with OTP verification here
    }
  }

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
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.8),
            ],
            stops: const [0.0, 0.6, 1.0],
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    'Please verify your account using the verification link sent to your email address.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 6; i++)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            onChanged: (value) => _onOtpChanged(value, i),
                            decoration: const InputDecoration(
                              counterText: "",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddInfo()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2c2c2c), // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'poppins'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _handleResend,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2c2c2c), // Set button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                      ),
                      child: Text(
                        _timeLeft > 0
                            ? 'Resend In: $_timeLeft'
                            : 'Resend Email',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'poppins'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
