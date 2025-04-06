import 'package:flutter/material.dart';
import 'package:menu/models/restaurant.dart';
import 'package:menu/pages/category_items_page.dart';

class RestaurantPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // معلومات العنوان والهاتف
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconRow(icon: Icons.location_on, text: restaurant.location),
                SizedBox(height: 8),
                IconRow(icon: Icons.phone, text: restaurant.phone),
              ],
            ),
          ),

          Divider(),

          // الأصناف
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "الأصناف",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // عرض الأصناف داخل GridView
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: restaurant.menu.length,
              itemBuilder: (context, index) {
                final category = restaurant.menu[index];
                return GestureDetector(
                  onTap: () {
                    // عند الضغط على الصنف، يتم الانتقال إلى صفحة الأصناف الخاصة به
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CategoryItemsPage(
                              categoryName: category,
                              restaurantId: restaurant.id,
                            ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget لعرض الأيقونات (الهاتف والعنوان)
class IconRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange),
        SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
      ],
    );
  }
}
