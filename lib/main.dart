import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'search_page.dart';
import 'topic_post_page.dart';
import 'FavoritePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DataBase.Init();
  runApp(MainApp()); //アプリを起動する
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // homeの引数に本体のページが入っている
    return MaterialApp(debugShowCheckedModeBanner: false, home: BaseView());
  }
}

class BaseView extends StatefulWidget {
  //タブを表示するページ
  @override
  _BaseViewState createState() => _BaseViewState();
}

// 状態を表すクラス
class _BaseViewState extends State<BaseView> {
  int _selectedPageIndex = 0;
  //タブで変更できるページが入っている
  static List<BasePage> _pageList = [
    TopicPage(),
    TopicPostPage(),
    SearchPage(),
    FavoritePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageList[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blueAccent,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorite',
          ),
        ],
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          //indexでどのタブが表示されているかわかる
          setState(() {
            _selectedPageIndex = index; //タップしたら表示内容を変える
          });
        },
      ),
    );
  }
}
