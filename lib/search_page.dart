import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';

class SearchPage extends BasePage{
  SearchPage({Key key}):super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>{
  int _displayMode = 0;
  static List<BaseTopicSubPage> _topicPages = [OneTopicSubPage(),TopicListSubPage()];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: _topicPages[_displayMode].icon,
            onPressed: () => setState((){
              _displayMode = ++_displayMode % _topicPages.length;
            }),
          )
        ],
      ),
      body: _topicPages[_displayMode],
    );
  }
}