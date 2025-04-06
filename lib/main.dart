import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MenuApp());
  int x = 0;
}

class MenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: MenuHomePage(),
    );
  }
}
