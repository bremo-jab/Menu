import 'package:flutter/material.dart';
import 'package:menu/widgets/restaurant_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/restaurant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              controller.dispose();
              final doc =
                  await FirebaseFirestore.instance
                      .collection("restaurants")
                      .doc(code)
                      .get();

              if (doc.exists) {
                final data = doc.data()!;
                final restaurant = Restaurant.fromMap(data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantPage(restaurant: restaurant),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("QR غير صالح أو غير موجود")),
                );
              }
              break;
            }
          }
        },
      ),
    );
  }
}
