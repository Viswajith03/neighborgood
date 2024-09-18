import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/drawer/drawer.dart';
import '../chat/chatscreen.dart';
import 'friendrequests.dart';
import '../profiles/userdetail.dart'; // Import user detail page if not already imported

class FriendsList extends StatefulWidget {
  const FriendsList({super.key});

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<dynamic> friends = [];
  List<dynamic> filteredFriends = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse("https://neighborgood.io/api/friends/"),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            friends = jsonDecode(response.body)['friends'];
            filteredFriends =
                friends; // Initialize filtered list with all friends
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load friends');
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching friends: $error');
      }
    }
  }

  void _filterFriends(String query) {
    setState(() {
      filteredFriends = friends.where((friend) {
        final name = friend['friend']['name'].toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      drawer: AppDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : friends.isEmpty
              ? const Center(child: Text('No friends found'))
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: const Color(0xffB3B3B3),
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                                color: Color(0xffB3B3B3),
                                fontFamily: 'poppins'),
                            suffixIcon: const Icon(Icons.search,
                                color: Color(0xffB3B3B3)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffB3B3B3)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffB3B3B3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: Color(0xffB3B3B3)),
                            ),
                          ),
                          onChanged: _filterFriends,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: filteredFriends.isEmpty
                          ? const Center(
                              child: Text(
                              'No friends match your search',
                              style: TextStyle(
                                  fontFamily: 'poppins', color: Colors.black),
                            ))
                          : ListView.builder(
                              itemCount: filteredFriends.length,
                              itemBuilder: (context, index) {
                                final friend = filteredFriends[index]['friend'];
                                return FriendListCard(data: friend);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

class FriendListCard extends StatelessWidget {
  final dynamic data;

  const FriendListCard({super.key, required this.data});

  void _startChat(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentUserId = prefs.getInt('userId');

    if (currentUserId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreenPage(
            recipientId: data['id'],
            recipientName: data['name'] ?? 'Unknown',
            recipientImage:
                data['picture'] ?? 'https://avatar.iran.liara.run/public',
            recipientImageUrl:
                data['picture'] ?? 'https://avatar.iran.liara.run/public',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to start chat. Please try again later.'),
        ),
      );
    }
  }

  void _viewUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide default values to avoid null issues
    String imageUrl = data['picture'] ?? 'https://avatar.iran.liara.run/public';
    String name = data['name'] ?? 'Sender\'s name';
    String city = data['address'] != null && data['address']['city'] != null
        ? data['address']['city'] as String
        : 'Unknown';
    String country =
        data['address'] != null && data['address']['country'] != null
            ? data['address']['country'] as String
            : 'Unknown';

    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.9; // Adjust the percentage as needed

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: GestureDetector(
        onTap: () => _viewUserProfile(context),
        child: SizedBox(
          width: cardWidth,
          child: Card(
            color: Colors.white,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '$city, $country',
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => _startChat(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffD9D9D9),
                          width: 1.5, // Adjust border width as needed
                        ),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
