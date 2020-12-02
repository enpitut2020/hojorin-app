import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'model/topic.dart';

class TopicPostPage extends BasePage {
  TopicPostPage({Key key}) : super(key: key, title: "Post Topic");
  @override
  State<StatefulWidget> createState() {
    return _TopicPostPageState();
  }
}

class _TopicPostPageState extends State<TopicPostPage> {
  Topic _topic = Topic("", List<String>());
  final TextEditingController _tagTextEditingController =
      TextEditingController();
  final TextEditingController _topicTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: onPostButtonPressed,
            )
          ],
        ),
        body: Column(children: <Widget>[
          TextField(
            decoration: new InputDecoration(
              hintText: "話題...",
            ),
            onSubmitted: onSubmittedTopicBody,
            //以下追加
            controller: _topicTextEditingController,
          ),
          TextField(
            decoration: new InputDecoration(
              hintText: "タグ...",
            ),
            onSubmitted: onSubmittedTopicTag,
            controller: _tagTextEditingController,
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
                    children: _topic.tags.map((String tag) {
                      return new Chip(label: Text("#" + tag));
                    }).toList(),
                  ),
                ),
              ])
        ]));
  }

  void onPostButtonPressed() {
    //話題投稿処理を書く
    DataBase.topics.add(_topic);
  }

  void onSubmittedTopicBody(String input) {
    _topic.body = input;
  }

  // Enterを押したときにタグが投稿された
  void onSubmittedTopicTag(String input) {
    setState(() {
      _topic.tags.add(input);
    });
    _tagTextEditingController.clear();
  }
}
