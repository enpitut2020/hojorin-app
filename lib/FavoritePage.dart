import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'model/topic.dart';
import 'base_page.dart';

class FavoritePage extends BasePage {
  FavoritePage({Key key}) : super(key: key, title: "Favorite");
  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {
  List<Topic> topics;
  int _displayMode = 0;
  static List<BaseTopicSubFavoritePage> _topicPages;
  @override
  initState() {
    super.initState();
    topics = DataBase.getFavoritedTopics();
    _topicPages = [
      OneTopicSubFavoritePage(topics: topics,updateFavoriteTopics: updateFavoriteTopics),
      TopicListSubFavoritePage(topics: topics),
    ];
  }

  updateFavoriteTopics()
  {
    setState((){
      topics = DataBase.getFavoritedTopics();
      _topicPages = [
        OneTopicSubFavoritePage(topics: topics,updateFavoriteTopics: updateFavoriteTopics),
        TopicListSubFavoritePage(topics: topics),
      ];
    });
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
              updateFavoriteTopics();
              _displayMode = ( 1 + _displayMode ) % _topicPages.length;
            }),
          )
        ],
      ),
      body: _topicPages[_displayMode],
    );
  }
}

abstract class BaseTopicSubFavoritePage extends StatefulWidget {
  BaseTopicSubFavoritePage({Key key, this.icon, this.topics, this.updateFavoriteTopics}) : super(key: key);
  final Icon icon;
  final List<Topic> topics;
  final Function updateFavoriteTopics;
}

// 1つ表示
class OneTopicSubFavoritePage extends BaseTopicSubFavoritePage {
  OneTopicSubFavoritePage({Key key, List<Topic> topics,Function updateFavoriteTopics})
      : super(
      key: key,
      icon: Icon(Icons.list, color: Colors.white),
      topics: topics,
      updateFavoriteTopics: updateFavoriteTopics);
  @override
  State<StatefulWidget> createState() {
    return _OneTopicSubPageFavoriteState();
  }
}

class _OneTopicSubPageFavoriteState extends State<OneTopicSubFavoritePage> {
  int _currentTopicIdx = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          //タップしたときの挙動
          setState(() {
            //表示する話題を更新
            if(widget.topics.length > 0){
              if(!widget.topics[_currentTopicIdx].isFavorite){
                widget.updateFavoriteTopics();
              }
              _currentTopicIdx = ( 1 + _currentTopicIdx ) % widget.topics.length;
            }
          });
        },
        child: createOneTopicCard(widget.topics.length > 0
            ? widget.topics[_currentTopicIdx]
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
                  topic.isFavorite = !topic.isFavorite;
                  DataBase.saveFavoriteInfo(topic.dataBaseID, topic.isFavorite);
                  setState(() {

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

class TopicListSubFavoritePage extends BaseTopicSubFavoritePage {
  TopicListSubFavoritePage({Key key, List<Topic> topics, Function updateFavoritedTopics})
      : super(
      key: key,
      icon: Icon(Icons.filter_none, color: Colors.white),
      topics: topics,
      updateFavoriteTopics: updateFavoritedTopics);
  State<StatefulWidget> createState() {
    return _TopicListSubPageFavoriteState();
  }
}

class _TopicListSubPageFavoriteState extends State<TopicListSubFavoritePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: widget.topics.map((Topic topic) {
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