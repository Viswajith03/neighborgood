import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:neighborgood/pages/card/pricing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Personalize extends StatefulWidget {
  const Personalize({super.key});

  @override
  State<Personalize> createState() => _PersonalizeState();
}

class _PersonalizeState extends State<Personalize> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _mileRadiusController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  late String _bearerToken;
  bool _isSending = false;
  bool _postcardCreated = false;
  bool _withPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _bearerToken = prefs.getString('token') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _submitPostcard() async {
    setState(() {
      _isSending = true;
    });

    final Map<String, dynamic> postData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "street": _streetController.text,
      "city": _cityController.text,
      "state": _stateController.text,
      "zipCode": _zipCodeController.text,
      "mileRadius": int.parse(_mileRadiusController.text),
    };

    String? base64Image;
    if (_withPhoto && _selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    if (base64Image != null) {
      postData["url"] = base64Image;
    }

    try {
      final url = Uri.parse('https://neighborgood.io/api/create-postcard/');
      final response = await http.post(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $_bearerToken',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(postData),
      );

      setState(() {
        _isSending = false;
      });

      if (response.statusCode == 201) {
        setState(() {
          _postcardCreated = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Postcard created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );

        final jsonResponse = jsonDecode(response.body);
        String? imageUrl = jsonResponse['image'];
        if (imageUrl != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('cardimg', imageUrl);
        }

        _clearFields();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Pricing()),
        );
      } else {
        _showError('Failed to create postcard. Please try again.');
      }
    } catch (error) {
      _showError('Failed to send postcard. Please try again.');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipCodeController.clear();
    _mileRadiusController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalize Postcard'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _nameController,
              labelText: 'Name',
              hintText: 'Enter your name',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _streetController,
              labelText: 'Street',
              hintText: 'Enter your street',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _cityController,
              labelText: 'City',
              hintText: 'Enter your city',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _stateController,
              labelText: 'State',
              hintText: 'Enter your state',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _zipCodeController,
              labelText: 'Zip Code',
              hintText: 'Enter your zip code',
            ),
            const SizedBox(height: 12.0),
            _buildTextField(
              controller: _mileRadiusController,
              labelText: 'Mile Radius',
              hintText: 'Enter mile radius',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            _buildPostcardTypeSelection(),
            const SizedBox(height: 16.0),
            if (_selectedImage != null) _buildSelectedImage(),
            _buildSubmitButton(),
            const SizedBox(height: 16.0),
            if (_postcardCreated)
              const Text(
                'Postcard created successfully!',
                style: TextStyle(color: Colors.green, fontFamily: 'Poppins'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFFF7800)),
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFFF7800)),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
      ],
    );
  }

  Widget _buildPostcardTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Postcard Type',
            style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins')),
        const SizedBox(height: 8.0),
        RadioListTile<bool>(
          title: const Text('Without Photo',
              style: TextStyle(fontFamily: 'Poppins')),
          value: false,
          groupValue: _withPhoto,
          onChanged: (value) {
            setState(() {
              _withPhoto = value!;
              _selectedImage = null; // Clear selected image if switching
            });
          },
          activeColor:
              const Color(0xFFFF7800), // Orange color for the radio button
        ),
        RadioListTile<bool>(
          title:
              const Text('With Photo', style: TextStyle(fontFamily: 'Poppins')),
          value: true,
          groupValue: _withPhoto,
          onChanged: (value) {
            setState(() {
              _withPhoto = value!;
            });
          },
          activeColor:
              const Color(0xFFFF7800), // Orange color for the radio button
        ),
        const SizedBox(height: 16.0),
        if (_withPhoto)
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFFF7800), // Orange background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            child: const Text('Select Image',
                style: TextStyle(
                    fontFamily: 'Poppins', color: Colors.white)), // White text
          ),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.file(
        File(_selectedImage!.path),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSending ? null : _submitPostcard,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF7800), // Orange background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: _isSending
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Send Postcard',
              style: TextStyle(
                  fontFamily: 'Poppins', color: Colors.white)), // White text
    );
  }
}
