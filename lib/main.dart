import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'search_page.dart';
import 'topic_post_page.dart';

void main() {
  DataBase.topics = [
    new Topic('今日ちょっと可愛くない？（or かっこよくない？）', ['ご機嫌取り']),
    new Topic('研究室決めた？', ['筑波大学3年生', '10月']),
    new Topic('その服似合ってるね', ['ご機嫌取り']),
    new Topic('ハロウィンなにかする?', ['10月']),
    new Topic('最近寒くなってきたよね', ['秋']),
    new Topic('体育何選択した?', ['情報科学類3年']),
    new Topic('TOEICの勉強とかしてる?', ['筑波大学3年生']),
    new Topic('バイトとかしてる?(バイト何してる?)', ['初対面', '学生'])
  ];
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: BaseView());
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
    TopicPostPage(),
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
            label: 'post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
