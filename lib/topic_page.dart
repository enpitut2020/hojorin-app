import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class WatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('FlutterとFirestoreの連携'),
          ),
          body: new TestList()),
    );
  }
}


class TopicPage extends BasePage{
  TopicPage({Key key}):super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState();
  }
}

class _TopicPageState extends State<TopicPage>{
  List<Topic> _topics;
  int _displayMode = 0;
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

// 以下追加部分
class TestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('topics').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.data()['topic']),
                  //subtitle: new Text(document.data()['content']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
// 追加部分終わり

abstract class BaseTopicSubPage extends StatefulWidget {
  BaseTopicSubPage({Key key, this.icon,this.topics}):super(key: key);
  final Icon icon;
  final List<Topic> topics;
}

class OneTopicSubPage extends BaseTopicSubPage{
  OneTopicSubPage({Key key, List<Topic> topics}):super(key: key,icon: Icon(Icons.list, color: Colors.white), topics: topics);
  @override
  State<StatefulWidget> createState() {
    return _OneTopicSubPageState();
  }
}

class _OneTopicSubPageState extends State<OneTopicSubPage>{
  Topic _currentTopic;
  int _currentTopicIdx;
  @override
  initState() {
    super.initState();
    _currentTopic = widget.topics.first;
    _currentTopicIdx = 0;
  }
  @override
  Widget build(BuildContext context){
    return Container(
        child: InkWell(
          onTap: (){
            setState((){
              _currentTopicIdx = ++_currentTopicIdx % widget.topics.length;
              _currentTopic = widget.topics[_currentTopicIdx];
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

class TopicListSubPage extends BaseTopicSubPage{
  TopicListSubPage({Key key, List<Topic> topics}):super(key: key,icon: Icon(Icons.filter_none, color: Colors.white), topics: topics);
  State<StatefulWidget> createState() {
    return _TopicListSubPageState();
  }
}

class _TopicListSubPageState extends State<TopicListSubPage>{
  @override
  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Container(
        child: ListView(
            children:
            widget.topics.map((Topic topic){
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