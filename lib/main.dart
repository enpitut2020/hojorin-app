import 'package:flutter/material.dart';
import 'model/topic.dart';

void main() {
  runApp(MaterialApp(
      home: TopicListPage()
  ));
}

class TopicListPage extends StatefulWidget{
  TopicListPage({Key key, this.title}):super(key: key);
  final String title;
  State<StatefulWidget> createState() {
    return _TopicListPageState();
  }
}

class _TopicListPageState extends State<TopicListPage>{
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('話題リスト'),
        ),
        body: InkWell(
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
      ),
    );
  }
}

