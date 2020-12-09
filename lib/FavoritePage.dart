import 'package:flutter/material.dart';
import 'topic_page.dart';
import 'base_page.dart';
import 'search_page.dart';

class FavoritePage extends BasePage {
  FavoritePage({Key key}):super(key: key, title: "Favorite");
  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add)
              )
            ]
        ),
        body: Column(
            children: <Widget>[
              Text(widget.title),
              Text(widget.title),
              Text(widget.title),
              Text(widget.title),
              Text(widget.title),
            ]
        )
    );
  }
}


