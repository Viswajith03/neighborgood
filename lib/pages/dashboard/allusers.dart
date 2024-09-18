import 'package:flutter/material.dart';
import '../../components/profilecard.dart';

class AllUsersScreen extends StatelessWidget {
  final List<dynamic> users;

  const AllUsersScreen({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: users.isEmpty
          ? const Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: _buildUserRows(users),
              ),
            ),
    );
  }

  List<Widget> _buildUserRows(List<dynamic> users) {
    List<Widget> userRows = [];

    for (int i = 0; i < users.length; i += 2) {
      List<Widget> rowChildren = [];

      for (int j = i; j < i + 2 && j < users.length; j++) {
        var user = users[j];
        String imageUrl =
            user['picture'] ?? 'https://avatar.iran.liara.run/public';
        String name = user['name'] ?? 'Unknown';
        String state = user['address']['state'] ?? 'Unknown';
        String country = user['address']['country'] ?? 'Unknown';
        String mobile = user['mobile'] ?? 'Unknown';

        rowChildren.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileCard(
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
      }

      if (rowChildren.length == 1) {
        rowChildren.add(const Expanded(child: SizedBox()));
      }

      userRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowChildren,
        ),
      );
    }

    return userRows;
  }
}
