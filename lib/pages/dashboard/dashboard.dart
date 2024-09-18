import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:neighborgood/pages/misc/chatwithai.dart';
import 'package:neighborgood/components/drawer/drawer.dart';
import 'package:neighborgood/pages/profiles/userdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/constants.dart';
import '../card/card.dart';
import '../find/findusers.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool _isLoading = true;
  List<dynamic> similarUsers = [];
  List<dynamic> similarUsersNotFromArea = [];
  List<dynamic> usersFromArea = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _refreshData() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse("https://neighborgood.io/api/similar_user/"),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          print(data); // Log the response data to check its structure

          setState(() {
            similarUsers = data['similar_users'] ?? [];
            similarUsersNotFromArea = data['similar_users_not_from_area'] ?? [];
            usersFromArea = data['users_from_area'] ?? [];
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load data');
        }
      } catch (error) {
        print(error); // Log any error during API fetch
        setState(() {
          _isLoading = false;
          // Optionally, show a user-friendly message
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Failed to load data. Please try again later.')));
        });
      }
    }
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: const Color(0xff18171C),
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins'), // Set the title text color to white
              bodyMedium: TextStyle(
                  color: Colors.white,
                  fontFamily: 'poppins',
                  fontSize: 18), // Set the content text color to white
            ),
          ),
          child: AlertDialog(
            content: const Text(
                'Great! You can invite your neighbors using our Physical Mail feature. We hope you will love it!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostcardPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFe59d14), // Set button color to e59d14
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(12), // Add button padding
                ),
                child: Text(
                  "Yes, Let's go",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'poppinsbold',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9ca3af),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(12), // Add button padding
                ),
                child: Text(
                  "No, not interested",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'poppinsbold',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _renderUserCards(List<dynamic> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        users.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No users found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : Column(
                children: users.map((user) {
                  String imageUrl = user['picture'] ??
                      'https://static.vecteezy.com/system/resources/previews/000/439/863/non_2x/vector-users-icon.jpg';
                  String name = user['name'] ?? 'Unknown';
                  String state = user['address']['state'] ?? 'Unknown';
                  String country = user['address']['country'] ?? 'Unknown';
                  String mobile = user['mobile'] ?? 'Unknown';
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProfileCard(
                      imageUrl: imageUrl,
                      name: name,
                      state: state,
                      country: country,
                      mobile: mobile,
                      user: user,
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VoiceflowWidget()),
          );
        },
        child: const Icon(Icons.chat),
      ),
      backgroundColor: const Color(0xff18171C),
      appBar: AppBar(
        backgroundColor: const Color(0xff18171C),
        title: const Text(
          "Neighborgood",
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xffE49C17),
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showInviteDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFFe59d14), // Set button color to e59d14
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(
                                      12), // Add button padding
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_add, color: Colors.white),
                                    SizedBox(
                                        width:
                                            8), // Add some space between icon and text
                                    Text(
                                      'Invite',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                width:
                                    16), // Add some space between the buttons
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  //
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => FindUsersScreen()),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(
                                      0xFFe59d14), // Set button color to e59d14
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(
                                      12), // Add button padding
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_search,
                                        color: Colors.white),
                                    SizedBox(
                                        width:
                                            8), // Add some space between icon and text
                                    Text(
                                      'Find',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Similar ',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Users',
                                    style: TextStyle(
                                      color: Color(0xffE49C17),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _renderUserCards(similarUsers),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Similar Users Outside Your ',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Region',
                                    style: TextStyle(
                                      color: Color(0xffE49C17),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _renderUserCards(similarUsersNotFromArea),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Local Users in Your ',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Vicinity',
                                    style: TextStyle(
                                      color: Color(0xffE49C17),
                                      fontSize: 25,
                                      fontFamily: 'poppinsbold',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        _renderUserCards(usersFromArea),
                      ],
                    )),
              ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String state;
  final String country;
  final String mobile;
  final Map<String, dynamic> user;

  const ProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.state,
    required this.country,
    required this.mobile,
    required this.user,
  });

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void Function()? _startChat(BuildContext context) {
    return () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? currentUserId = prefs.getInt('userId');

      if (currentUserId != null) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatScreen(
        //       userId: currentUserId,
        //       recipientId: user['id'], // Assuming user data has an 'id' field
        //     ),
        //   ),
        // );
      } else {
        // Handle the case where currentUserId is null
        print('Current user ID not found in SharedPreferences');
        // Optionally, show a user-friendly message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Failed to start chat. Please try again later.')));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color(0xFF2C2834),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150, // Adjust the height of the image container as needed
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/user.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 8), // Add spacing between the image and text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 20,
                          fontFamily: 'poppinsbold',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '$state, $country',
                          style: TextStyle(
                              fontSize: 16, color: Color(0xffA4A4A4))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
              height: 8), // Add spacing between the details and icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.person, color: Color(0xffA4A4A4)),
              ),
              IconButton(
                onPressed: () {
                  _launchPhoneDialer(mobile);
                },
                icon: const Icon(Icons.phone, color: Color(0xffA4A4A4)),
              ),
              IconButton(
                onPressed: _startChat(context),
                icon: const Icon(Icons.message, color: Color(0xffA4A4A4)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
