import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constants.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _userData = {}; // Initialize with an empty map
  bool _isLoading = false;
  int id = 0; // Initialize with a default value
  String token = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('userId') ?? 4;
      token = prefs.getString('token') ?? '';
    });

    try {
      final apiUrl = 'https://neighborgood.io/api/user/?id=$id';
      print('Fetching user data from $apiUrl');
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['user'];
        print('User data fetched: $userData');
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user data: $error');
    }
  }

  void _editProfile() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => EditUserProfile(userData: _userData),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text('My Profile',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData.isNotEmpty
              ? Container(
                  child: _buildUserProfile(),
                )
              : const Center(
                  child: Text('User data not available',
                      style: TextStyle(color: Colors.black)),
                ),
    );
  }

  Widget _buildUserProfile() {
    String imageUrl = _userData['picture'] ??
        'https://static.vecteezy.com/system/resources/previews/000/439/863/non_2x/vector-users-icon.jpg';
    String name = _userData['name'] ?? 'Unknown';
    String age = _userData['age']?.toString() ?? 'Unknown';
    String email = _userData['email'] ?? 'Unknown';
    String phone = _userData['mobile'] ?? 'Unknown';
    String countryCode = _userData['countryCode'] ?? '';
    String address = _userData['address']?['label'] ?? 'Unknown';
    String bio = _userData['bio'] ?? 'No bio available';

    // Extract interests and favours
    Map<String, List<Map<String, dynamic>>> extractedData =
        extractInterestsAndFavours(_userData);
    List<Map<String, dynamic>> interests = extractedData['interests'] ?? [];
    List<Map<String, dynamic>> favours = extractedData['favours'] ?? [];

    print('Interests: $interests');
    print('Favours: $favours');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Age: $age',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: $email',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Phone: $phone',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Country Code: $countryCode',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Address: $address',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Display Interests and Favours in a table
          Table(
            border: TableBorder.all(color: const Color(0xFFA4A4A4)),
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Table Header
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Interest/Favour',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              // Interests
              for (var interest in interests)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        interest['name'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        interest['details'] != null && interest['details'] != ''
                            ? interest['details']!
                            : 'Yes',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              // Favours
              for (var favour in favours)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        favour['name'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        favour['details'] != null && favour['details'] != ''
                            ? favour['details']!
                            : 'Yes',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> extractInterestsAndFavours(
      Map<String, dynamic> data) {
    List<Map<String, dynamic>> interests = [];
    List<Map<String, dynamic>> favours = [];

    data.forEach((key, value) {
      if (value is Map && value['interested'] != null) {
        bool isInterested = value['interested'] is bool
            ? value['interested']
            : value['interested']['interested'];
        String details = detailsToString(value['details']);
        if (isInterested) {
          interests.add({
            'name': key[0].toUpperCase() + key.substring(1),
            'details': details,
          });
        } else {
          favours.add({
            'name': key[0].toUpperCase() + key.substring(1),
            'details': details,
          });
        }
      }
    });

    return {'interests': interests, 'favours': favours};
  }

  String detailsToString(dynamic details) {
    if (details == null || details == '') {
      return 'No';
    }
    if (details is String) {
      return details;
    }
    if (details is List) {
      return details.join(', ');
    }
    return details.toString();
  }
}

class EditUserProfile extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditUserProfile({super.key, required this.userData});

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['name'] ?? '';
    // Initialize other controllers with existing data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            // Add more form fields for other user details
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    String token = '';
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print('token = $token');

    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> updatedUserData = {};

      // Update only the fields that have been edited
      if (_nameController.text != widget.userData['name']) {
        updatedUserData['name'] = _nameController.text;
      }

      // Add similar checks and updates for other editable fields

      if (updatedUserData.isNotEmpty) {
        try {
          const apiUrl = 'https://neighborgood.io/api/edit_info/';
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(updatedUserData),
          );

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);
            print('User data updated successfully: $responseData');
            // Update local user data state or navigate back (optional)
            Navigator.of(context).pop();
          } else {
            throw Exception('Failed to update user data');
          }
        } catch (error) {
          print('Error updating user data: $error');
        }
      } else {
        print('No changes detected in user data');
      }
    }
  }
}
