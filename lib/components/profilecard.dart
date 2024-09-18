import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../pages/profiles/userdetail.dart';

class ProfileCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String state;
  final String country;
  final String mobile;
  final dynamic user;

  const ProfileCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.state,
    required this.country,
    required this.mobile,
    required this.user,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isLoading = false;
  bool isFriendRequestSent = false;
  bool isFriend = false;

  @override
  void initState() {
    super.initState();
    isFriendRequestSent = widget.user['friend_request_sent'] ?? false;
    isFriend = widget.user['is_friend'] ?? false;
  }

  Future<void> sendFriendRequest() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('https://neighborgood.io/api/send_friend_request/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'receiver_id': widget.user['id'],
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            isFriendRequestSent = true;
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'Friend request sent successfully');
        } else {
          throw Exception('Failed to send friend request');
        }
      } catch (error) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: 'Failed to send friend request. Please try again later.');
      }
    }
  }

  void navigateToUserDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailPage(user: widget.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToUserDetailPage(context),
      child: SizedBox(
        height: 230,
        child: Card(
          elevation: 4.0, // Adjust the elevation as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://avatar.iran.liara.run/public',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        '${widget.state}, ${widget.country}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : isFriend
                              ? ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    'Already Friends',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: isFriendRequestSent
                                      ? null
                                      : sendFriendRequest,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFriendRequestSent
                                        ? const Color(0xffe3e3e3)
                                        : const Color(0xffe3e3e3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    isFriendRequestSent
                                        ? 'Request Sent'
                                        : 'Add Friend',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        color: Colors.black),
                                  ),
                                ),
                    ],
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
