import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Pricing extends StatefulWidget {
  const Pricing({super.key});

  @override
  _PricingState createState() => _PricingState();
}

class _PricingState extends State<Pricing> {
  String selectedQuantity = '250 Recipients'; // Default value
  double pricePerPostcard = 0.61; // Price per postcard
  final TextEditingController _couponController = TextEditingController();
  bool isDiscountApplied = false;
  double discountPercentage = 0.33;
  String imageUrl = ''; // Variable to hold the image URL

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('cardimg') ?? '';
    });
  }

  Future<String> fetchPaymentIntentClientSecret() async {
    // Replace this with your actual backend API call to fetch client secret
    // Example: Replace `your_backend_url` with your actual backend API endpoint
    final response = await http
        .get(Uri.parse('https://neighborgood.io/api/create_checkout_session/'));

    if (response.statusCode == 200) {
      // Parse the JSON response and extract the client secret
      final json = jsonDecode(response.body);
      return json['clientSecret'];
    } else {
      throw Exception('Failed to load client secret');
    }
  }

  Future<String> createCheckoutSession(String clientSecret) async {
    try {
      final url =
          Uri.parse('https://neighborgood.io/api/create_checkout_session/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': 'John Doe',
        'city': 'New York',
        'street': '123 Main St',
        'state': 'NY',
        'zipCode': '10001',
        'mileRadius': '5',
        'quantity': '250',
        'email': 'john.doe@example.com',
        'frontImageUrl': 'https://example.com/image.jpg',
        'discount_code': _couponController.text.trim(),
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['checkout_url'];
      } else {
        throw Exception('Failed to create checkout session');
      }
    } catch (e) {
      print('Error creating checkout session: $e');
      throw Exception('Failed to create checkout session');
    }
  }

  Future<void> onPayPressed() async {
    try {
      // Fetch client secret from your backend
      final clientSecret = await fetchPaymentIntentClientSecret();

      // Create checkout session with your backend
      final checkoutUrl = await createCheckoutSession(clientSecret);

      // Open the checkout URL in a web view or browser
      await launch(
          checkoutUrl); // Import 'package:url_launcher/url_launcher.dart';

      // Handle successful initiation of payment
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment initiated')),
      );
    } catch (e) {
      // Handle payment initiation failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initiate payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        pricePerPostcard * (selectedQuantity == '250 Recipients' ? 250 : 500);
    double discountedAmount = totalAmount * (1 - discountPercentage);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Send A Postcard',
            style: TextStyle(fontFamily: 'poppins'),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display network image fetched from shared preferences
              if (imageUrl.isNotEmpty) Image.network(imageUrl),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Quantity',
                            labelStyle: const TextStyle(
                                fontFamily: 'poppins', color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          value: selectedQuantity,
                          items: const [
                            DropdownMenuItem<String>(
                              value: '250 Recipients',
                              child: Text('250 Recipients'),
                            ),
                            DropdownMenuItem<String>(
                              value: '500 Recipients',
                              child: Text('500 Recipients'),
                            ),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              selectedQuantity = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Stack(
                          children: [
                            TextFormField(
                              controller: _couponController,
                              decoration: InputDecoration(
                                labelText: 'Enter your coupon code',
                                labelStyle: const TextStyle(
                                    fontFamily: 'poppins', color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(12, 12, 104, 12),
                              ),
                              style: const TextStyle(fontFamily: 'poppins'),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFF7E1D0),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (_couponController.text
                                              .toLowerCase() ==
                                          'christine') {
                                        isDiscountApplied = true;
                                      } else {
                                        isDiscountApplied = false;
                                      }
                                    });
                                  },
                                  child: const Text(
                                    'Apply',
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DottedBorder(
                          color: Colors.black,
                          strokeWidth: 0.5,
                          dashPattern: const [6, 4],
                          strokeCap: StrokeCap.round,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Total Payable Amount:',
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isDiscountApplied)
                                      Text(
                                        '\$${totalAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    Text(
                                      '\$${(isDiscountApplied ? discountedAmount : totalAmount).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.9, // Adjust width as needed
                            child: ElevatedButton(
                              onPressed: onPayPressed,
                              style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                padding:
                                    WidgetStateProperty.all<EdgeInsetsGeometry>(
                                  const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 32.0),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(
                                          0xFFFF7800); // Color on hover
                                    }
                                    return const Color(
                                        0xFF2c2c2c); // Default color
                                  },
                                ),
                              ),
                              child: Text(
                                isDiscountApplied
                                    ? "Pay \$${discountedAmount.toStringAsFixed(2)}"
                                    : "Pay \$${totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'poppins',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
