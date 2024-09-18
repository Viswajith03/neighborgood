import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../friends/friendrequests.dart';
import 'chatscreen.dart'; // Import your ChatScreenPage here

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chatUsers = []; // List to hold fetched chat users
  List<dynamic> filteredUsers = []; // List to hold filtered chat users
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChatUsers();
  }

  Future<void> fetchChatUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      // Handle case where userId or token is not available
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://neighborgood.io/api/chat_users/?user_id=$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          chatUsers = data['users'] ?? [];
          filteredUsers =
              chatUsers; // Initialize filtered users with all chat users
        });
      } else {
        throw Exception('Failed to load chat users');
      }
    } catch (error) {
      print('Error fetching chat users: $error');
    }
  }

  // Function to format the time in 12-hour format with 4 digits
  String formatTime(String timeString) {
    DateTime time =
        DateTime.parse(timeString).toLocal(); // Parse UTC time to local time
    return DateFormat('h:mm a').format(time);
  }

  // Function to filter chat users based on search query
  void _filterRequests(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredUsers = chatUsers.where((user) {
          String userName = user['name'].toString().toLowerCase();
          return userName.contains(query.toLowerCase());
        }).toList();
      } else {
        filteredUsers = chatUsers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "My Friends",
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FriendRequestsScreen()),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/navLogo.svg',
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _searchController,
              cursorColor: const Color(0xffB3B3B3),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                    color: Color(0xffB3B3B3), fontFamily: 'poppins'),
                suffixIcon: const Icon(Icons.search, color: Color(0xffB3B3B3)),
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
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredUsers.length,
              separatorBuilder: (context, index) => Divider(
                height: 0,
                color: Colors.grey[400],
              ),
              itemBuilder: (context, index) {
                var user = filteredUsers[index];
                var lastMessage = user['last_message']['message'];
                var lastMessageTime = user['last_message']['time'];

                // Check for null values and provide fallbacks if necessary
                var pictureUrl =
                    user['picture'] ?? 'https://avatar.iran.liara.run/public';
                var userName = user['name'] ?? 'Unknown';

                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(30), // Make it circular
                    child: Container(
                      width: 60, // Width of the square avatar
                      height: 60, // Height of the square avatar
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(pictureUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$lastMessage',
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'poppins'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTime(lastMessageTime),
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'poppins'),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to ChatScreen with user ID and recipient details when tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreenPage(
                          recipientId: user['id'],
                          recipientName:
                              userName, // Use the fallback value here
                          recipientImage: pictureUrl,
                          recipientImageUrl:
                              'pictureUrl', // Use the fallback value here
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
