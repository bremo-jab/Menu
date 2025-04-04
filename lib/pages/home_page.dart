import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/auto_scroll_image_strip.dart';
import 'qr_scan_page.dart';
import 'package:permission_handler/permission_handler.dart';

class MenuHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // صورة ترحيبية
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_960_720.jpg",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Welcome to Our Restaurant",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // شريط الصور المتحركة
                AutoScrollImageStrip(),

                // الفئات
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CategoryCard(icon: Icons.fastfood, label: "Main Dishes"),
                      CategoryCard(icon: Icons.local_pizza, label: "Pizzas"),
                      CategoryCard(icon: Icons.cake, label: "Desserts"),
                      CategoryCard(icon: Icons.local_drink, label: "Drinks"),
                    ],
                  ),
                ),

                SizedBox(height: 150),
              ],
            ),
          ),

          // زر QR في منتصف الشاشة
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
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
