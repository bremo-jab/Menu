import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_page.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleQRCode(String code) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    controller.stop();

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection("restaurants")
              .doc(code)
              .get();

      if (doc.exists) {
        final data = doc.data()!;
        final restaurant = Restaurant.fromMap(data, doc.id);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantPage(restaurant: restaurant),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("QR غير صالح أو غير موجود")));
        controller.start();
        setState(() => _isProcessing = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء المسح")));
      controller.start();
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              handleQRCode(code);
              break;
            }
          }
        },
      ),
    );
  }
}
