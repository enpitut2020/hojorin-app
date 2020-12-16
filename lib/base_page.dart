import 'package:flutter/material.dart';

// タブで移動できるページのひな形
abstract class BasePage extends StatefulWidget {
  BasePage({Key key, this.title}) : super(key: key);
  final String title;
}
