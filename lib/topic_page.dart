import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DataBase {
  static List<Topic> topics;
}

class TopicPage extends BasePage {
  //BasePage（ひな形）を継承
  TopicPage({Key key}) : super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState(); //次どのような状態かを返す
  }
}

// 状態をつかさどるやつ（コア）
class _TopicPageState extends State<TopicPage> {
  List<Topic> _topics;
  int _displayMode = 0;
  static List<BaseTopicSubPage> _topicPages;

  @override
  initState() {
    super.initState();
    // _topics = [
    //   new Topic('今日ちょっと可愛くない？（or かっこよくない？）', ['ご機嫌取り']),
    //   new Topic('研究室決めた？', ['筑波大学3年生', '10月']),
    //   new Topic('その服似合ってるね', ['ご機嫌取り']),
    //   new Topic('ハロウィンなにかする?', ['10月']),
    //   new Topic('最近寒くなってきたよね', ['秋']),
    //   new Topic('体育何選択した?', ['情報科学類3年']),
    //   new Topic('TOEICの勉強とかしてる?', ['筑波大学3年生']),
    //   new Topic('バイトとかしてる?(バイト何してる?)', ['初対面', '学生'])
    // ];
    // 一つ表示かリスト表示か
    _topicPages = [
      OneTopicSubPage(topics: _topics),
      TopicListSubPage(topics: _topics)
    ];

    // Firestoreから最新のsnapshotをとってくる
    FirebaseFirestore.instance
        .collection('topics')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        DataBase.topics = snapshot.docs.map((DocumentSnapshot document) {
          return new Topic(document.data()['topic'],
              document.data()['tags'].cast<String>() as List<String>);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // リストか1つかの表示切替のボタン
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

// ひな形
abstract class BaseTopicSubPage extends StatefulWidget {
  BaseTopicSubPage({Key key, this.icon, this.topics}) : super(key: key);
  final Icon icon;
  final List<Topic> topics;
}

// 1つ表示の表示内容
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
    //_currentTopic = widget.topics.first; //最初の話題が取得できる
    _currentTopicIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          //タップしたときの挙動
          setState(() {
            //表示する話題の変数を更新
            _currentTopicIdx = ++_currentTopicIdx % DataBase.topics.length;
            //_currentTopic = widget.topics[_currentTopicIdx];
          });
        },
        child: createTopicCard(
            DataBase.topics != null ? DataBase.topics[_currentTopicIdx] : null),
      ),
    );
  }

  Widget createTopicCard(Topic topic) {
    if (topic == null)
      return Container();
    else {
      return Card(
        child: Column(
          //縦に並べる
          children: <Widget>[
            // 話題テキスト本文
            Text(topic.body, style: TextStyle(fontSize: 30)),
            // タグ(CreateTopicTags関数を見よ)
            createTopicTags(topic),
          ],
        ),
      );
    }
  }

  Row createTopicTags(Topic topic) {
    // タグの表示（Rowで横に並べる）
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          //余白を埋める
          child: Wrap(
            //おり返す
            alignment: WrapAlignment.start,
            spacing: 8.0,
            runSpacing: 0.0,
            direction: Axis.horizontal,
            children: topic.tags.map((String tag) {
              //タグの文字列
              return new Chip(label: Text("#" + tag));
            }).toList(), //リスト化
          ),
        ),
      ],
    );
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
        //children: widget.topics.map((Topic topic) {
        children: DataBase.topics.map((Topic topic) {
          return new Card(
            child: Column(
              children: <Widget>[
                Text(topic.body, style: TextStyle(fontSize: 30)),
                // Row部分は1つ表示の部分と同じコード
                Row(
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
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
