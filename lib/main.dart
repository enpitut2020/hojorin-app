import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'search_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BaseView()
    );
  }
}

class BaseView extends StatefulWidget {
  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  int _selectedPageIndex = 0;
  static List<BasePage> _pageList = [
    TopicPage(),
    TopicPage(),
    SearchPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'topic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index){ setState((){_selectedPageIndex = index;}); },
      ),
    );
  }
}
