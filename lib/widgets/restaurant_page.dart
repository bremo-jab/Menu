import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("الاسم: ${restaurant.name}", style: TextStyle(fontSize: 20)),
            Text(
              "العنوان: ${restaurant.location}",
              style: TextStyle(fontSize: 18),
            ),
            Text("الهاتف: ${restaurant.phone}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              "الأصناف:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...restaurant.menu.map((item) => ListTile(title: Text(item))),
          ],
        ),
      ),
    );
  }
}
