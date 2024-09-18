import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FindUsersScreen extends StatefulWidget {
  const FindUsersScreen({super.key});

  @override
  _FindUsersScreenState createState() => _FindUsersScreenState();
}

class _FindUsersScreenState extends State<FindUsersScreen> {
  bool isLoading = false;
  List<dynamic> similarUsers = [];
  String? latitude;
  String? longitude;
  String? selectedRange;

  Future<void> findUsers(
      String latitude, String longitude, String range) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    if (token != null) {
      try {
        setState(() {
          isLoading = true;
        });

        final response = await http.post(
          Uri.parse("https://neighborgood.io/api/find-user/"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "location": {
              "lattitude": double.parse(latitude),
              "longitude": double.parse(longitude),
            },
            "range": range,
          }),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          print("Fetched data: $data"); // Log the response data

          setState(() {
            similarUsers = data['nearby_users'] ?? [];
            isLoading = false;
          });
        } else {
          throw Exception(
              'Failed to load data. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print("Error: $error"); // Log any caught errors
        setState(() {
          isLoading = false;
          // Show a user-friendly message
          Fluttertoast.showToast(
            msg: 'Failed to load data. Please try again later.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        });
      }
    } else {
      print("Token is null. User not authenticated.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Find a User'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Latitude', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      latitude = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Longitude', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      longitude = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text('Select Range'),
                    ),
                    value: selectedRange,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRange = newValue!;
                      });
                    },
                    items: <String>['5', '10', '20', '50']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('<$value km'),
                            ),
                          ),
                        )
                        .toList(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    elevation: 8,
                    dropdownColor:
                        Colors.white, // Customize the dropdown background color
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                    selectedItemBuilder: (BuildContext context) {
                      return <String>['5', '10', '20', '50']
                          .map<Widget>((String value) {
                        return Center(
                          child: Text(
                            '<$value km',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),

                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (latitude != null &&
                  //         longitude != null &&
                  //         selectedRange != null) {
                  //       findUsers(latitude!, longitude!, selectedRange!);
                  //     } else {
                  //       Fluttertoast.showToast(
                  //         msg: 'Please fill in all fields',
                  //         toastLength: Toast.LENGTH_SHORT,
                  //         gravity: ToastGravity.BOTTOM,
                  //       );
                  //     }
                  //   },
                  //   child: Text('Find'),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: () {
                        if (latitude != null &&
                            longitude != null &&
                            selectedRange != null) {
                          findUsers(latitude!, longitude!, selectedRange!);
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Please fill in all fields',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 32.0), // Reduced vertical padding
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return const Color(0xFFFF7800); // Color on hover
                            }
                            return const Color(0xFF2c2c2c); // Default color
                          },
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          Text(
                            " Find Users",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'poppins',
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator() // Show loading indicator when fetching data
                : similarUsers.isEmpty
                    ? const Text(
                        'No users found',
                        style: TextStyle(fontFamily: 'poppins'),
                      ) // Show message if no users found
                    : SingleChildScrollView(
                        child: Column(
                          children: similarUsers.map((user) {
                            // Display user cards
                            return ProfileSearchCard(
                              imageUrl: user['picture'] ??
                                  'https://via.placeholder.com/150',
                              name: user['name'] ?? 'Unknown',
                              state: user['address']['state'] ?? 'Unknown',
                              country: user['address']['country'] ?? 'Unknown',
                              mobile: user['mobile'] ?? 'Unknown',
                              user: user,
                            );
                          }).toList(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class ProfileSearchCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String state;
  final String country;
  final String mobile;
  final Map<String, dynamic> user;

  const ProfileSearchCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.state,
    required this.country,
    required this.mobile,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text('$state, $country\nMobile: $mobile'),
      ),
    );
  }
}
