import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class RestaurantsListPage extends StatefulWidget {
  @override
  _RestaurantsListPageState createState() => _RestaurantsListPageState();
}

class _RestaurantsListPageState extends State<RestaurantsListPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuHomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('هذه صفحة قائمة المطاعم')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الصفحة الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_restaurant),
            label: 'قائمة المطاعم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'تسجيل الدخول',
          ),
        ],
      ),
    );
  }
}
