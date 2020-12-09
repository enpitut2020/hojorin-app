import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';

class DataBase {
  static List<Topic> topics;
  static List<Topic> favoriteTopics;

  static Init() {
    topics = [
      new Topic('今日ちょっと可愛くない？（or かっこよくない？）', ['ご機嫌取り']),
      new Topic('研究室決めた？', ['筑波大学3年生', '10月']),
      new Topic('その服似合ってるね', ['ご機嫌取り']),
      new Topic('ハロウィンなにかする?', ['10月']),
      new Topic('最近寒くなってきたよね', ['秋']),
      new Topic('体育何選択した?', ['情報科学類3年']),
      new Topic('TOEICの勉強とかしてる?', ['筑波大学3年生']),
      new Topic('バイトとかしてる?(バイト何してる?)', ['初対面', '学生'])
    ];
    favoriteTopics = [];
  }
}

class TopicPage extends BasePage {
  TopicPage({Key key}) : super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState();
  }
}

class _TopicPageState extends State<TopicPage> {
  //List<Topic> _topics;
  int _displayMode = 0;
  static List<BaseTopicSubPage> _topicPages;
  @override
  initState() {
    super.initState();

    _topicPages = [
      OneTopicSubPage(topics: DataBase.topics),
      TopicListSubPage(topics: DataBase.topics)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: _topicPages[_displayMode].icon,
            onPressed: () => setState(() {
              _displayMode = ++_displayMode % _topicPages.length;
            }),
          )
        ],
      ),
      body: _topicPages[_displayMode],
    );
  }
}

abstract class BaseTopicSubPage extends StatefulWidget {
  BaseTopicSubPage({Key key, this.icon, this.topics}) : super(key: key);
  final Icon icon;
  final List<Topic> topics; //DataBase.Topicが渡ってる？
}

class OneTopicSubPage extends BaseTopicSubPage {
  OneTopicSubPage({Key key, List<Topic> topics})
      : super(
            key: key,
            icon: Icon(Icons.list, color: Colors.white),
            topics: topics);
  @override
  State<StatefulWidget> createState() {
    return _OneTopicSubPageState();
  }
}

class _OneTopicSubPageState extends State<OneTopicSubPage> {
  Topic _currentTopic;
  int _currentTopicIdx;
  @override
  initState() {
    super.initState();
    _currentTopic = widget.topics.first;
    _currentTopicIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {
        setState(() {
          _currentTopicIdx = ++_currentTopicIdx % widget.topics.length;
          _currentTopic = widget.topics[_currentTopicIdx];
        });
      },
      child: Column(
        children: <Widget>[
          Card(
              child: Column(children: <Widget>[
            Text(_currentTopic.body, style: TextStyle(fontSize: 30)),
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
                      children: _currentTopic.tags.map((String tag) {
                        return new Chip(label: Text("#" + tag));
                      }).toList(),
                    ),
                  ),
                ])
          ])),
          RaisedButton(
            child: const Icon(Icons.favorite, color: Colors.redAccent),
            color: Colors.white,
            shape: const CircleBorder(
              side: BorderSide(
                color: Colors.red,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    ));
  }
}

class TopicListSubPage extends BaseTopicSubPage {
  TopicListSubPage({Key key, List<Topic> topics})
      : super(
            key: key,
            icon: Icon(Icons.filter_none, color: Colors.white),
            topics: topics);
  State<StatefulWidget> createState() {
    return _TopicListSubPageState();
  }
}

class _TopicListSubPageState extends State<TopicListSubPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
            children: widget.topics.map((Topic topic) {
      return new Card(
          child: Column(children: <Widget>[
        Text(topic.body, style: TextStyle(fontSize: 30)),
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
                  children: topic.tags.map((String tag) {
                    return new Chip(label: Text('#' + tag));
                  }).toList(),
                ),
              ),
            ])
      ]));
    }).toList()));
  }
}
