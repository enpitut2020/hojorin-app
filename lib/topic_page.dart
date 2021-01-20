import 'package:flutter/material.dart';
import 'model/topic.dart';
import 'base_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBase {
  static List<Topic> topics;
  static List<Topic> favoriteTopics;

  static Init() {
    //topics = [
    //  new Topic('今日ちょっと可愛くない？（or かっこよくない？）', ['ご機嫌取り']),
    //  new Topic('研究室決めた？', ['筑波大学3年生', '10月']),
    //  new Topic('その服似合ってるね', ['ご機嫌取り']),
    //  new Topic('ハロウィンなにかする?', ['10月']),
    //  new Topic('最近寒くなってきたよね', ['秋']),
    //  new Topic('体育何選択した?', ['情報科学類3年']),
    //  new Topic('TOEICの勉強とかしてる?', ['筑波大学3年生']),
    //  new Topic('バイトとかしてる?(バイト何してる?)', ['初対面', '学生'])
    //];
    topics = [];
    favoriteTopics = [];
  }
}

class TopicPage extends BasePage {
  TopicPage({Key key}) : super(key: key, title: "Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPageState(); //次どのような状態かを返す
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

    // Firestoreから最新のsnapshotをとってくる
    FirebaseFirestore.instance
        .collection('topics')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        List<Topic> tmp = DataBase.topics;
        DataBase.topics = snapshot.docs.map((DocumentSnapshot document) {
          Topic newTopic = Topic(document.data()['topic'],
              document.data()['tags'].cast<String>() as List<String>);
          newTopic.dataBaseID = document.id;
          return newTopic;
        }).toList();
        for (var topic in tmp) {
          Topic find = DataBase.topics.firstWhere(
              (element) => topic.dataBaseID == element.dataBaseID,
              orElse: () => null);
          if (find != null) {
            find.isFavorite = topic.isFavorite;
          }
        }
      });
    });
    getFavoriteInfo().then((favoritedIDList) {
      for (Topic topic in DataBase.topics) {
        if (favoritedIDList.contains(topic.dataBaseID)) {
          topic.isFavorite = true;
        } else {
          topic.isFavorite = false;
        }
      }
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
  final List<Topic> topics; //DataBase.Topicが渡ってる？
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
            //表示する話題の変数を更新
            _currentTopicIdx = ++_currentTopicIdx % DataBase.topics.length;
            //_currentTopic = widget.topics[_currentTopicIdx];
          });
        },
        child: createWindow(DataBase.topics.length > 0
            ? DataBase.topics[_currentTopicIdx]
            : null),
      ),
    );
  }

  Widget createWindow(Topic topic) {
    if (topic == null)
      return Container();
    else {
      //return Column(
      return Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //縦に並べる
            children: <Widget>[
              // 話題テキスト本文
              Text(topic.body, style: TextStyle(fontSize: 30)),
              // タグ(CreateTopicTags関数を見よ)
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
                    saveFavoriteInfo(topic.dataBaseID, topic.isFavorite);
                    if (topic.isFavorite)
                      DataBase.favoriteTopics.add(topic);
                    else
                      DataBase.favoriteTopics.remove(topic);
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

//ユーザー認証の機能をつけてゆくゆくはDBにお気に入り情報を保持するが一旦
//ローカルに保存
void saveFavoriteInfo(String id, bool isFavorite) async {
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

Future<List<String>> getFavoriteInfo() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> favoritedIDList = pref.getStringList("FavoritedIDList");
  if (favoritedIDList == null) {
    favoritedIDList = List<String>();
  }
  return Future.value(favoritedIDList);
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
