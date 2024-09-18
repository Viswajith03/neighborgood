import 'dart:convert';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:neighborgood/pages/misc/chatwithai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/drawer/drawer.dart';
import '../card/card.dart';
import '../find/findusers.dart';
import '../friends/friendlist.dart';
import '../friends/friendrequests.dart';
import '../profiles/userdetail.dart';
import 'allusers.dart';

class AltDashboard extends StatefulWidget {
  const AltDashboard({super.key});

  @override
  _AltDashboardState createState() => _AltDashboardState();
}

class _AltDashboardState extends State<AltDashboard>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<dynamic> similarUsers = [];
  List<dynamic> similarUsersNotFromArea = [];
  List<dynamic> usersFromArea = [];
  bool _disposed = false; // Track if the widget is disposed
  String _userImageUrl = '';

  late TabController _tabController;

  @override
  void dispose() {
    _disposed = true; // Set disposed to true when disposing the widget
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
    _getUserImage();
  }

  Future<void> _getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userImageUrl = prefs.getString('picture') ?? '';
    });
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

        if (!_disposed) {
          if (response.statusCode == 200) {
            Map<String, dynamic> data = jsonDecode(response.body);
            setState(() {
              similarUsers = data['similar_users'] ?? [];
              similarUsersNotFromArea =
                  data['similar_users_not_from_area'] ?? [];
              usersFromArea = data['users_from_area'] ?? [];
              _isLoading = false;
            });
          } else {
            throw Exception('Failed to load data');
          }
        }
      } catch (error) {
        if (!_disposed) {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Failed to load data. Please try again later.')),
            );
          });
        }
      }
    }
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                color: Colors.black,
                fontFamily: 'poppins',
              ), // Set the title text color to black
              bodyMedium: TextStyle(
                color: Colors.black,
                fontFamily: 'poppins',
                fontSize: 18,
              ), // Set the content text color to black
            ),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Reduce the border radius
            ),
            content: const Text(
              'Great! You can invite your neighbors using our Physical Mail feature. We hope you will love it!',
              style: TextStyle(fontFamily: 'poppins'),
            ),
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
              const SizedBox(height: 10),
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
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No users found',
          style: TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    // Limit to the first 6 users
    final displayedUsers = users.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Similar Users',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllUsersScreen(users: users),
                    ),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items in a row
              childAspectRatio: 0.75, // Adjusted to make the cards taller
            ),
            itemCount: displayedUsers.length,
            itemBuilder: (context, index) {
              final user = displayedUsers[index];
              String imageUrl = user['picture'] ??
                  'https://static.vecteezy.com/system/resources/previews/000/439/863/non_2x/vector-users-icon.jpg';
              String name = user['name'] ?? 'Unknown';
              String state = user['address']['state'] ?? 'Unknown';
              String country = user['address']['country'] ?? 'Unknown';
              String mobile = user['mobile'] ?? 'Unknown';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white, // Set the background color to white
                  child: SizedBox(
                    width: double.infinity,
                    child: ProfileMainCard(
                      imageUrl: imageUrl,
                      name: name,
                      state: state,
                      country: country,
                      mobile: mobile,
                      user: user,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Neighborgood",
          style: TextStyle(
            fontFamily: 'poppins',
            fontSize: 20,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
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
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  GestureDetector(
                    onTap: () => _showInviteDialog(context),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Image.asset('assets/postcardhome.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.9, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FindUsersScreen()),
                        );
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomSlidingSegmentedControl<int>(
                      initialValue: 0,
                      onValueChanged: (int? newValue) {
                        _tabController.animateTo(newValue ?? 0);
                      },
                      children: const {
                        0: const Text(
                          'Users near me',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        1: const Text(
                          'Other Users',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.bold),
                        ),
                      },
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: const Color(0xffffdbc9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _renderUserCards(usersFromArea),
                        _renderUserCards(similarUsersNotFromArea),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: CircleAvatar(
          backgroundColor: Colors.black,
          child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VoiceflowWidget()),
                );
              },
              icon: const Icon(
                Icons.message_outlined,
                color: Colors.white,
              ))),
    );
  }
}

class ProfileMainCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String state;
  final String country;
  final String mobile;
  final dynamic user;

  const ProfileMainCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.state,
    required this.country,
    required this.mobile,
    required this.user,
  });

  @override
  _ProfileMainCardState createState() => _ProfileMainCardState();
}

class _ProfileMainCardState extends State<ProfileMainCard> {
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
