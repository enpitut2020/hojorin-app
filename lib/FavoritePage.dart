import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'model/topic.dart';
import 'base_page.dart';
import 'search_page.dart';

class FavoritePage extends BasePage {
  FavoritePage({Key key}) : super(key: key, title: "Favorite");
  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {
  //List<Topic> _topics;
  int _displayMode = 0;
  static List<BaseTopicSubPage> _topicPages;
  @override
  initState() {
    super.initState();

    _topicPages = [
      OneTopicSubPage(topics: DataBase.favoriteTopics),
      TopicListSubPage(topics: DataBase.favoriteTopics),
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
  bool _isFavorite;

  @override
  initState() {
    super.initState();
    _currentTopic = null;

    _currentTopicIdx = 0;
    _isFavorite = false;
  }

  @override
  Widget build(BuildContext context) {
    //return Text('あいうえお');
    return Container(
        child: InkWell(
      onTap: () {
        setState(() {
          _currentTopicIdx =
              ++_currentTopicIdx % DataBase.favoriteTopics.length;
          _currentTopic = DataBase.favoriteTopics[_currentTopicIdx];
          _isFavorite = true;
        });
      },
      child: createFavoriteList(),
      //child: Text('あいう'),
    ));
  }

  // お気に入りリストページを生成する関数
  Widget createFavoriteList() {
    if (DataBase.favoriteTopics.length <= 0)
      return Container();
    else {
      //本当はこの処理は、このページを下のタブで開いた瞬間によびたい
      if (_currentTopic == null) {
        _currentTopic = DataBase.favoriteTopics[_currentTopicIdx];
        _isFavorite = true;
      }
      return Column(
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
            child: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border,
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
                _isFavorite = !_isFavorite;
                if (_isFavorite)
                  DataBase.favoriteTopics.add(_currentTopic);
                else
                  DataBase.favoriteTopics.remove(_currentTopic);
              });
            },
          ),
        ],
      );
    }
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
