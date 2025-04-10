import 'package:flutter/material.dart';
import 'package:menu/pages/category_items_page.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String restaurantId;  // إضافة معرّف المطعم

  CategoryCard({required this.icon, required this.label, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () {
          // عند الضغط على الكارد، يمكن الانتقال إلى صفحة الأصناف الخاصة بالصنف
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryItemsPage(
                categoryName: label,
                restaurantId: restaurantId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.orange),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
