import 'package:flutter/material.dart';
import 'scanner_page.dart';
import 'violation_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(
      child: Text(
        "Student Violation Dashboard",
        style: TextStyle(fontSize: 18),
      ),
    ),
    ScannerPage(),
    ViolationListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ACLC Violation System")),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF002147),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: "Scan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Violations"),
        ],
      ),
    );
  }
}
