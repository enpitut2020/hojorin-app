import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'model/topic.dart';

class SearchPage extends BasePage{
  SearchPage({Key key}):super(key: key, title: "Search");
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>{
  int _displayMode = 0;
  List<Topic> _topics;
  static List<BaseTopicSubPage> _topicPages;
  @override
  initState() {
    super.initState();
    _topics = [
      new Topic('今日ちょっと可愛くない？（or かっこよくない？）',['ご機嫌取り']),
      new Topic('研究室決めた？',['筑波大学3年生','10月']),new Topic('その服似合ってるね',['ご機嫌取り']),
      new Topic('ハロウィンなにかする?',['10月']), new Topic('最近寒くなってきたよね',['秋']),
      new Topic('体育何選択した?',['情報科学類3年']), new Topic('TOEICの勉強とかしてる?',['筑波大学3年生']),
      new Topic('バイトとかしてる?(バイト何してる?)',['初対面','学生'])
    ];
    _topicPages = [OneTopicSubPage(topics: _topics),TopicListSubPage(topics: _topics)];
  }
  List<Topic> searchTopics(String conditionText){
    List<String> conditions = conditionText.split((' '));
    return _topics.where((topic) =>
      topic.tags.any((tag) =>
        conditions.contains(tag)
      )
    );
  }

  void onSubmitCondition(String conditionText)
  {
    setState((){
      _topics = searchTopics(conditionText);
      _topicPages = [OneTopicSubPage(topics: _topics),TopicListSubPage(topics: _topics)];
    });

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: new TextField(
          style: new TextStyle(
            color: Colors.white,

          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)
          ),
          onSubmitted: onSubmitCondition,
        ),
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
