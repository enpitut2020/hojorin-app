import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';

class TopicPage extends BasePage{
  TopicPage({Key key}):super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState();
  }
}

class _TopicPageState extends State<TopicPage>{
  int _displayMode = 0;
  static List<BaseTopicPage> _topicPages = [OneTopicPage(),TopicListPage()];
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

abstract class BaseTopicPage extends StatefulWidget {
  BaseTopicPage({Key key, this.icon}):super(key: key);
  final Icon icon;
}

class OneTopicPage extends BaseTopicPage{
  OneTopicPage({Key key}):super(key: key,icon: Icon(Icons.list, color: Color.fromRGBO(255, 255, 255, 1)));
  @override
  State<StatefulWidget> createState() {
    return _OneTopicPageState();
  }
}

class _OneTopicPageState extends State<OneTopicPage>{
  List<Topic> _topics;
  Topic _currentTopic;
  int _currentTopicIdx;
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
    _currentTopic = _topics.first;
    _currentTopicIdx = 0;
  }
  @override
  Widget build(BuildContext context){
    return Container(
        child: InkWell(
          onTap: (){
            setState((){
              _currentTopicIdx = ++_currentTopicIdx % _topics.length;
              _currentTopic = _topics[_currentTopicIdx];
            });
          },
          child: Card(
              child: Column(
                  children: <Widget>[
                    Text(
                        _currentTopic.body,
                        style: TextStyle(fontSize: 30)
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 8.0,
                              runSpacing: 0.0,
                              direction: Axis.horizontal,
                              children: _currentTopic.tags.map((String tag){
                                return new Chip(label:Text("#"+tag));
                              }).toList(),
                            ),
                          ),
                        ]
                    )
                  ]
              )
          ),
        )
    );
  }
}

class TopicListPage extends BaseTopicPage{
  TopicListPage({Key key}):super(key: key,icon: Icon(Icons.filter_none, color: Color.fromRGBO(255, 255, 255, 1)));
  State<StatefulWidget> createState() {
    return _TopicListPageState();
  }
}

class _TopicListPageState extends State<TopicListPage>{
  List<Topic> _topics;
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
  }
  @override
  Widget build(BuildContext context){
    return Container(
        child: ListView(
            children:
            _topics.map((Topic topic){
              return new Card(
                  child: Column(
                      children: <Widget>[
                        Text(
                            topic.body,
                            style: TextStyle(fontSize: 30)
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 0.0,
                                  direction: Axis.horizontal,
                                  children: topic.tags.map((String tag){
                                    return new Chip(label:Text('#'+tag));
                                  }).toList(),
                                ),
                              ),
                            ]
                        )
                      ]
                  )
              );
            }).toList()
        )
    );
  }
}