import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:neighborgood/pages/card/personalize.dart';

class PostcardPage extends StatefulWidget {
  const PostcardPage({super.key});

  @override
  State<PostcardPage> createState() => _PostcardPageState();
}

class _PostcardPageState extends State<PostcardPage> {
  double pricePerPostcard = 0.61; // Price per postcard
  final TextEditingController _couponController = TextEditingController();
  bool isDiscountApplied = false;
  double discountPercentage = 0.33;
  double totalAmount = 0.0;
  double discountedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    totalAmount = pricePerPostcard * 250;
    discountedAmount = totalAmount * (1 - discountPercentage);
  }

  Widget _buildHeaderImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoundedImage("assets/user1.jpg"),
        _buildRoundedImage("assets/user2.jpg"),
        _buildRoundedImage("assets/user3.jpg"),
        _buildRoundedImage("assets/user4.jpg"),
        _buildRoundedImage("assets/user5.jpg"),
      ],
    );
  }

  Widget _buildRoundedImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage(assetPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Send A Postcard",
          style: TextStyle(fontFamily: 'poppins', color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/asset1.png', height: 150),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gift your neighborhood the joy of connecting by blasting out an invitation to your neighborhood',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF7800),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'With just a few clicks, you can gift your community the connection and support of NeighbourGood by sending a postcard to your neighbors.',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                items: [
                  buildImageSlider(context, 'assets/card1.jpeg'),
                  buildImageSlider(context, 'assets/card2.jpeg'),
                  buildImageSlider(context, 'assets/card3.jpeg'),
                  buildImageSlider(context, 'assets/card4.jpeg'),
                ],
                options: CarouselOptions(
                  height: 300,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '\$${pricePerPostcard.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          '/ per postcard',
                          style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '* Inclusive of all taxes',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'More information about Postcard',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCostBreakdown(),
                    const SizedBox(height: 20),
                    _buildDeliveryInformation(),
                    const SizedBox(height: 20),
                    _buildContinueButton(context),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildImageSlider(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Hero(
                  tag: imagePath,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        );
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        height: 300,
      ),
    );
  }

  Widget _buildCostBreakdown() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '250 Recipients',
                style: TextStyle(fontFamily: 'poppins', fontSize: 18),
              ),
              Text(
                '\$${(pricePerPostcard * 250).toStringAsFixed(2)}',
                style: const TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '500 Recipients',
                style: TextStyle(fontFamily: 'poppins', fontSize: 18),
              ),
              Text(
                '\$${(pricePerPostcard * 500).toStringAsFixed(2)}',
                style: const TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Cost Breakdown',
          style: TextStyle(color: Color(0xff838383), fontFamily: 'poppins'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCostItem('Printing', '\$0.11'),
            _buildCostItem('Postage', '\$0.5'),
          ],
        ),
      ],
    );
  }

  Widget _buildCostItem(String label, String cost) {
    return DottedBorder(
      color: Colors.black,
      strokeWidth: 0.5,
      dashPattern: const [6, 4],
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: const Radius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              '$label  ',
              style: const TextStyle(
                  color: Color(0xff838383), fontFamily: 'poppins'),
            ),
            Text(
              cost,
              style:
                  const TextStyle(color: Colors.black, fontFamily: 'poppins'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Postcard',
          style: TextStyle(color: Color(0xff838383), fontFamily: 'poppins'),
        ),
        const Text(
          '> It’s a Neighborgood Invitation Physical Mail.',
          style: TextStyle(fontFamily: 'poppins'),
        ),
        const Text(
          '> Size of Postcard - 4" x 6" Inches.',
          style: TextStyle(fontFamily: 'poppins'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Information about delivery',
          style: TextStyle(color: Color(0xff838383), fontFamily: 'poppins'),
        ),
        const SizedBox(height: 10),
        _buildDeliveryItem('Ships From', 'EDDM USPS'),
        const SizedBox(height: 10),
        _buildDeliveryItem('Printing From', 'Vistaprint'),
      ],
    );
  }

  Widget _buildDeliveryItem(String label, String value) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '$label  ',
                  style: const TextStyle(
                      color: Color(0xff838383), fontFamily: 'poppins'),
                ),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'poppins'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Personalize()),
          );
        },
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color(0xFFFF7800);
              }
              return const Color(0xFF2c2c2c);
            },
          ),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'poppins',
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.transparent],
          stops: [0.7, 1.0],
        ).createShader(bounds);
      },
      child: SizedBox(
        width: double.infinity,
        height: 350, // Height for the image area
        child: Stack(
          children: [
            Positioned(
              left: -314,
              top: -114,
              child: SizedBox(
                width: 932.49,
                height: 1024,
                child: Stack(
                  children: [
                    Positioned(
                      left: 144,
                      top: 0,
                      child: Opacity(
                        opacity: 0.75,
                        child: SizedBox(
                          width: 788.49,
                          height: 488.49,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 359.78,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..translate(0.0, 0.0)
                                    ..rotateZ(-0.79),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          _buildImageContainer(
                                              "assets/user1.jpg", 0.50),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user2.jpg", 0.75),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user3.jpg", 0.80),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user4.jpg", 0.80),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _buildImageContainer(
                                              "assets/user5.jpg", 0.60),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user6.jpg", 0.70),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user7.jpg", 0.85),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user8.jpg", 0.90),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user9.jpg", 0.55),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _buildImageContainer(
                                              "assets/user9.jpg", 0.55),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user1.jpg", 0.65),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user2.jpg", 0.75),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user3.jpg", 0.85),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user3.jpg", 0.80),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _buildImageContainer(
                                              "assets/user4.jpg", 0.70),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user5.jpg", 0.80),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user6.jpg", 0.90),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user7.jpg", 0.95),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _buildImageContainer(
                                              "assets/user8.jpg", 0.60),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user9.jpg", 0.70),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user1.jpg", 0.80),
                                          const SizedBox(width: 16),
                                          _buildImageContainer(
                                              "assets/user2.jpg", 0.90),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(String assetPath, double opacity) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}
