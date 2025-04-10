import 'package:flutter/material.dart';

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
