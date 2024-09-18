import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserDetailPage({super.key, required this.user});

  void _launchPhoneDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = user['picture'] ??
        'https://static.vecteezy.com/system/resources/previews/000/439/863/non_2x/vector-users-icon.jpg';
    String name = user['name'] ?? 'Unknown';
    String age = user['age'] ?? 'Unknown';
    String email = user['email'] ?? 'Unknown';
    String phone = user['mobile'] ?? 'Unknown';
    String countryCode = user['countryCode'] ?? '';
    String address = user['address']['label'] ?? 'Unknown';
    String bio = 'No bio available'; // Assuming bio is static in this case.

    // Helper function to convert dynamic details to string
    String detailsToString(dynamic details) {
      if (details == null) {
        return 'No details available';
      }
      if (details is String) {
        return details;
      }
      if (details is List) {
        return details.join(', ');
      }
      return details.toString();
    }

    // Function to extract interests and favours
    Map<String, List<Map<String, dynamic>>> extractInterestsAndFavours(
        Map<String, dynamic> data) {
      List<Map<String, dynamic>> interests = [];
      List<Map<String, dynamic>> favours = [];

      data.forEach((key, value) {
        if (value is Map && value['interested'] == true) {
          if (key == 'walking' ||
              key == 'running' ||
              key == 'gardening' ||
              key == 'swimming' ||
              key == 'coffeeTea' ||
              key == 'art' ||
              key == 'foodGathering' ||
              key == 'sports' ||
              key == 'movies') {
            interests.add({
              'name': key.capitalize(),
              'details': detailsToString(value['details'])
            });
          } else {
            favours.add({
              'name': key.capitalize(),
              'details': detailsToString(value['details'])
            });
          }
        }
      });

      return {'interests': interests, 'favours': favours};
    }

    // Extract interests and favours
    Map<String, List<Map<String, dynamic>>> interestsAndFavours =
        extractInterestsAndFavours(user);
    List<Map<String, dynamic>> interests =
        interestsAndFavours['interests'] ?? [];
    List<Map<String, dynamic>> favours = interestsAndFavours['favours'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(name,
            style: const TextStyle(fontFamily: 'poppins', color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE49C17),
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
              Table(
                border: TableBorder.all(color: const Color(0xFFA4A4A4)),
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
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
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            interest['details'] ?? 'No details available',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            favour['details'] ?? 'No details available',
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
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }
}
