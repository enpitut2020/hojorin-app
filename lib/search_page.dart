import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'model/topic.dart';

class SearchPage extends BasePage {
  SearchPage({Key key}) : super(key: key, title: "Search");
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  int _displayMode = 0;
  List<Topic> _topics;
  static List<BaseTopicSubPage> _topicPages;
  @override
  initState() {
    super.initState();
    _topics = DataBase.topics;
    _topicPages = createTopicSubPages(_topics);
  }

  List<Topic> searchTopics(String conditionText) {
    List<String> conditions = conditionText.split((' '));
    return DataBase.topics
        .where((topic) => topic.tags.any((tag) => conditions.contains(tag)));
  }

  void onSubmitCondition(String conditionText) {
    setState(() {
      _topics = searchTopics(conditionText);
      _topicPages = createTopicSubPages(_topics);
    });
  }

  List<BaseTopicSubPage> createTopicSubPages(List<Topic> topics){
    return [
      OneTopicSubPage(topics: topics),
      TopicListSubPage(topics: topics)
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new TextField(
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)),
          onSubmitted: onSubmitCondition,
        ),
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
