//Packages
import 'package:flutter/material.dart';

//Pages
import '../pages/chats_page.dart';
import '../pages/search_page.dart';
import '../pages/esports_page.dart';
import '../pages/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;

  final List<Widget> _pages = [
    const EsportsPage(),
    const ChatsPage(),
    SearchPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(
            () {
              _currentPage = index;
            },
          );
        },
        items: const [
          BottomNavigationBarItem(
            label: "Esports",
            icon: Icon(
              Icons.sports_esports,
            ),
          ),
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(
              Icons.search,
            ),
          ),
          BottomNavigationBarItem(
            label: "User",
            icon: Icon(
              Icons.person_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
