import 'dart:async';

import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ローカルに話題を保持していたときの名残
//いつか消す
//現状はローカルにお気に入りを保持しているのでその処理とtopicsの提供をFireBaseと仲介
class DataBase {
  static List<Topic> topics=[];
  static List<Topic> getFavoritedTopics()
  {
    return topics.where((topic) => topic.isFavorite).toList();
  }
  static void getTopicsUpdateFromFireBase(AsyncSnapshot<QuerySnapshot> snapshot)
  {
    List<Topic> updatedTopics = snapshot.data.docs.map((DocumentSnapshot document) {
      Topic updatedTopic = Topic(document.data()['topic'],
          document.data()['tags'].cast<String>() as List<String>);
      updatedTopic.dataBaseID = document.id;
      return updatedTopic;
    }).toList();
    for (var topic in topics) {
      Topic find = updatedTopics.firstWhere(
              (element) => topic.dataBaseID == element.dataBaseID,
          orElse: () => null);
      if (find != null) {
        find.isFavorite = topic.isFavorite;
      }
    }
    topics = updatedTopics;
  }

  static Future<void> init() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('topics').get();
    topics = snapshot.docs.map((DocumentSnapshot document) {
      Topic updatedTopic = Topic(document.data()['topic'],
          document.data()['tags'].cast<String>() as List<String>);
      updatedTopic.dataBaseID = document.id;
      return updatedTopic;
    }).toList();
    List<String> favoritedIDList = await getFavoriteInfo();
    for (Topic topic in DataBase.topics) {
      if (favoritedIDList.contains(topic.dataBaseID)) {
        topic.isFavorite = true;
      } else {
        topic.isFavorite = false;
      }
    }
  }

  //ユーザー認証の機能をつけてゆくゆくはDBにお気に入り情報を保持するが一旦
//ローカルに保存
  static void saveFavoriteInfo(String id, bool isFavorite) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> favoritedIDList = pref.getStringList("FavoritedIDList");
    if (favoritedIDList == null) {
      favoritedIDList = List<String>();
    } else if (favoritedIDList.contains(id)) {
      if (!isFavorite) {
        favoritedIDList.remove(id);
      }
    } else if (isFavorite) {
      favoritedIDList.add(id);
    }
    await pref.setStringList("FavoritedIDList", favoritedIDList);
  }

  static Future<List<String>> getFavoriteInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> favoritedIDList = pref.getStringList("FavoritedIDList");
    if (favoritedIDList == null) {
      favoritedIDList = List<String>();
    }
    return Future.value(favoritedIDList);
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
  List<Topic> _topics;
  int _displayMode = 0;
  static List<BaseTopicSubPage> _topicPages;

  @override
  initState() {
    super.initState();
    // 一つ表示かリスト表示か
    _topicPages = [
      OneTopicSubPage(topics: _topics),
      TopicListSubPage(topics: _topics)
    ];
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
      body: StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance
            .collection('topics')
            .snapshots(),
          builder : (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('');
            }
            DataBase.getTopicsUpdateFromFireBase(snapshot);
            return _topicPages[_displayMode];
          }
      ),
    );
  }
}

abstract class BaseTopicSubPage extends StatefulWidget {
  BaseTopicSubPage({Key key, this.icon, this.topics}) : super(key: key);
  final Icon icon;
  final List<Topic> topics;
}

// 1つ表示
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
  int _currentTopicIdx = 0;

  @override
  initState() {
    super.initState();
    //_currentTopic = widget.topics.first; //最初の話題が取得できる
    //_currentTopicIdx = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          //タップしたときの挙動
          setState(() {
            //表示する話題を更新
            if(DataBase.topics.length > 0){
              _currentTopicIdx = ( 1 + _currentTopicIdx ) % DataBase.topics.length;
            }
          });
        },
        child: createOneTopicCard(DataBase.topics.length > 0
            ? DataBase.topics[_currentTopicIdx]
            : null),
      ),
    );
  }

  Widget createOneTopicCard(Topic topic) {
    if (topic == null)
      return Container();
    else {
      //return Column(
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 話題テキスト本文
              Text(topic.body, style: TextStyle(fontSize: 30)),
              // タグ
              createTopicTags(topic),
              RaisedButton(
                child: Icon(
                    topic.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent),
                color: Colors.white,
                shape: const CircleBorder(
                  side: BorderSide(
                    color: Colors.red,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    topic.isFavorite = !topic.isFavorite;
                    DataBase.saveFavoriteInfo(topic.dataBaseID, topic.isFavorite);
                  });
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Row createTopicTags(Topic topic) {
    return Row(
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
              //タグの文字列
              return new Chip(label: Text("#" + tag));
            }).toList(),
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
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // 話題テキスト本文
                Text(topic.body, style: TextStyle(fontSize: 30)),
                // タグ
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
                          //タグの文字列
                          return new Chip(label: Text("#" + tag));
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  child: Icon(
                      topic.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.redAccent),
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: Colors.red,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      topic.isFavorite = !topic.isFavorite;
                      DataBase.saveFavoriteInfo(topic.dataBaseID, topic.isFavorite);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
