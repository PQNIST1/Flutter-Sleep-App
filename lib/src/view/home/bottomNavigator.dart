import 'package:flutter/material.dart';
import 'package:sleep/src/view/home/home_screen.dart';

import '../../themes.dart';
import '../details/custom.dart';
class BottomNavigationExample extends StatefulWidget {
  @override
  _BottomNavigationExampleState createState() => _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CustomSound(),
    PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: kPrimaryColor.withOpacity(0.9), // Thay đổi màu sắc ở đây
        selectedItemColor: Colors.white, // Màu sắc cho các mục được chọn
        unselectedItemColor: Colors.grey, // Màu sắc cho các mục chưa được chọn
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/equalizer.png',width: 20,height: 20,fit: BoxFit.cover,),
            label: 'Kết hợp',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/music.png',width: 20,height: 20,fit: BoxFit.cover),
            label: 'Âm thanh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}
class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Center(
        child: Text(
          'This is Page Two',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Three'),
      ),
      body: Center(
        child: Text(
          'This is Page Three',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}