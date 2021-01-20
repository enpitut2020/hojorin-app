import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'model/topic.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            RaisedButton(
              child: const Text('投稿'),
              color: Colors.white,
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: onPostButtonPressed,
            ),
          ],
        ),
        body: Column(children: <Widget>[
          TextField(
            decoration: new InputDecoration(
              hintText: "話題...",
            ),
            //onSubmitted: onSubmittedTopicBody,
            onChanged: onChangedTopicBody,
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
    //Firebaseへの話題投稿処理を書く
    //参考：https://firebase.flutter.dev/docs/firestore/usage/
    //Fluttertoast.showToast(msg: "話題を投稿しました");
    FirebaseFirestore.instance
        .collection('topics')
        .add({"topic": _topic.body, "tags": _topic.tags});
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("話題を投稿しました"),
    ));
    //内容を消す
    _tagTextEditingController.clear();
    _topicTextEditingController.clear();
    setState(() {
      _topic.tags.clear();
    });
  }

  //void onSubmittedTopicBody(String input) {
  //  _topic.body = input;
  //}
  void onChangedTopicBody(String input) {
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
