import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'qr_scan_page.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/auto_scroll_image_strip.dart';
import 'dart:math';

class MenuHomePage extends StatefulWidget {
  @override
  _MenuHomePageState createState() => _MenuHomePageState();
}

class _MenuHomePageState extends State<MenuHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? coverImageUrl;
  List<Color> buttonColors = [Colors.orange, Colors.red, Colors.blue];
  Random random = Random();

  List<String> titles = [
    "اختيارات فريق مينيو لناس يميزها الذوق",
    "اقتراحاتنا الخاصة لذوقك الراقي",
    "مينيو يختار لك الأفضل دائماً",
  ];
  String selectedTitle = "";
  Color titleBorderColor = Colors.transparent;
  late Color titleTextColor;

  late Color qrColor;
  late Color textColor;
  late Color borderColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _getCoverImage();
    _randomizeTitleAndBorderColor();
    _initializeColors();
  }

  void _randomizeTitleAndBorderColor() {
    selectedTitle = titles[random.nextInt(titles.length)];
    titleBorderColor = getRandomLightTransparentColor();
    titleTextColor = getRandomDarkColor();
  }

  void _initializeColors() {
    qrColor = getRandomDarkColor();
    textColor = getRandomDarkColor();
    borderColor = getRandomLightTransparentColor();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getCoverImage() async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('app_data')
              .doc('home_data')
              .get();
      if (docSnapshot.exists) {
        setState(() {
          coverImageUrl = docSnapshot['coverImage'];
        });
      }
    } catch (e) {
      print('Error fetching cover image: $e');
    }
  }

  List<Color> getRandomGradientColors() {
    buttonColors.shuffle(random);
    return buttonColors;
  }

  Color getRandomDarkColor() {
    List<Color> darkColors = [
      Colors.black,
      Colors.brown,
      Colors.indigo,
      Colors.teal,
    ];
    return darkColors[random.nextInt(darkColors.length)];
  }

  Color getRandomLightTransparentColor() {
    List<Color> lightColors = [
      Colors.amber,
      Colors.cyan,
      Colors.lime,
      Colors.pink,
    ];
    return lightColors[random.nextInt(lightColors.length)].withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final coverImageHeight = screenHeight * 0.30;
    final qrHeight = screenHeight * 0.30;
    final spacingBetweenCoverAndQR = screenHeight * 0.05;
    final spacingBetweenQRAndTitle = screenHeight * 0.05;
    final titleHeight = screenHeight * 0.30 * 0.25;
    final scrollingStripHeight = screenHeight * 0.30 * 0.75;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                coverImageUrl != null
                    ? Container(
                      height: coverImageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(coverImageUrl!),
                          fit: BoxFit.fill, ////////////////
                        ),
                      ),
                    )
                    : Container(height: coverImageHeight, color: Colors.grey),
                SizedBox(height: spacingBetweenCoverAndQR),
              ],
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                var status = await Permission.camera.request();
                if (status.isGranted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Camera permission denied")),
                  );
                }
              },
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: double.infinity,
                      height: qrHeight,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: getRandomGradientColors(),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner, size: 60, color: qrColor),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: borderColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "انقر لمسح رمز الاستجابة QR Code",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: spacingBetweenQRAndTitle),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: titleBorderColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: titleTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 0),
                Container(
                  height: scrollingStripHeight,
                  child: AutoScrollImageStrip(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
