import 'package:flutter/material.dart';
import 'package:menu/models/restaurant.dart';
import 'package:menu/widgets/icon_row.dart';
import '../widgets/category_card.dart';  // تم إضافته أيضًا
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

          // عرض الأصناف داخل GridView باستخدام CategoryCard
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
                final icon = getCategoryIcon(category);  // استدعاء دالة الأيقونة

                return CategoryCard(
                  icon: icon,
                  label: category,
                  restaurantId: restaurant.id,  // تمرير معرف المطعم
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة لاختيار الأيقونة حسب الصنف
  IconData getCategoryIcon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains("مشروب")) return Icons.local_drink;
    if (lower.contains("حلويات")) return Icons.cake;
    if (lower.contains("وجبات") || lower.contains("مأكولات")) return Icons.fastfood;
    if (lower.contains("فطور")) return Icons.breakfast_dining;
    if (lower.contains("سندويش")) return Icons.lunch_dining;
    return Icons.restaurant_menu;
  }
}
