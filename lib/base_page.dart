import 'package:flutter/material.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({Key key, this.title}):super(key: key);
  final String title;
}