import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../profiles/userdetail.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  List<dynamic> friendRequests = [];
  List<dynamic> filteredRequests = [];
  bool isLoading = true;
  String _userImageUrl = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
    _getUserImage();
  }

  Future<void> fetchFriendRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse("https://neighborgood.io/api/friend_requests/"),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            friendRequests = jsonDecode(response.body)['friend_requests'];
            filteredRequests = friendRequests;
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load friend requests');
        }
      } catch (error) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Failed to load friend requests. Please try again later.')),
          );
        });
      }
    }
  }

  Future<void> _getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userImageUrl = prefs.getString('picture') ?? '';
    });
  }

  Future<void> acceptFriendRequest(int requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse("https://neighborgood.io/api/accept_friend_request/"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'request_id': requestId}),
        );

        if (response.statusCode == 200) {
          setState(() {
            friendRequests =
                friendRequests.where((req) => req['id'] != requestId).toList();
            filteredRequests = friendRequests;
          });
          Fluttertoast.showToast(
            msg: "Friend request accepted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          throw Exception('Failed to accept friend request');
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Failed to accept friend request",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> rejectFriendRequest(int requestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse("https://neighborgood.io/api/reject_friend_request/"),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({'request_id': requestId}),
        );

        if (response.statusCode == 200) {
          setState(() {
            friendRequests =
                friendRequests.where((req) => req['id'] != requestId).toList();
            filteredRequests = friendRequests;
          });
          Fluttertoast.showToast(
            msg: "Friend request rejected!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          throw Exception('Failed to reject friend request');
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Failed to reject friend request",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void _filterRequests(String query) {
    setState(() {
      filteredRequests = friendRequests
          .where((request) => request['sender']['name']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Friend Requests',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          if (_userImageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  image: DecorationImage(
                    image: NetworkImage(_userImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  controller: _searchController,
                  cursorColor: const Color(0xffB3B3B3),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                        color: Color(0xffB3B3B3), fontFamily: 'poppins'),
                    suffixIcon:
                        const Icon(Icons.search, color: Color(0xffB3B3B3)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xffB3B3B3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xffB3B3B3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Color(0xffB3B3B3)),
                    ),
                  ),
                  onChanged: _filterRequests,
                ),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRequests.isEmpty
                    ? const Center(
                        child: Text(
                        'No friend requests',
                        style: TextStyle(fontFamily: 'poppins'),
                      ))
                    : SingleChildScrollView(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredRequests.length,
                          itemBuilder: (context, index) {
                            final request = filteredRequests[index];
                            return FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailPage(
                                            user: request['sender']),
                                      ),
                                    );
                                  },
                                  child: FriendRequestCard(
                                    request: request,
                                    acceptFriendRequest: acceptFriendRequest,
                                    rejectFriendRequest: rejectFriendRequest,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class FriendRequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final Function(int) acceptFriendRequest;
  final Function(int) rejectFriendRequest;

  const FriendRequestCard({
    super.key,
    required this.request,
    required this.acceptFriendRequest,
    required this.rejectFriendRequest,
  });

  @override
  Widget build(BuildContext context) {
    final address = request['sender']['address'];
    final addressString =
        "${address['city']}, ${address['state']}, ${address['country']}";

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
            color: Color(0xffB3B3B3), width: 1.0), // Add border to the card
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80, // Increase the width
              height: 90, // Increase the height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(request['sender']['picture'] ??
                      'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
                width: 8), // Add some space between the image and the text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request['sender']['name'],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                      height: 4), // Add some space between name and address
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          addressString,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 8), // Add some space between address and buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => rejectFriendRequest(request['id']),
                        child: const Text(
                          'Ignore',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Color(0xff7D7983),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => acceptFriendRequest(request['id']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFF7800), // Set the button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16), // Set the border radius
                          ),
                        ),
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
