import 'package:flutter/material.dart';
import 'webservice.dart';
import 'dart:convert';

class Item extends StatefulWidget {
  Item({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  ItemStructure _item;
  @override
  void initState() {
    super.initState();
    _populateItem();
  }

  void _populateItem() {
    Webservice().load(ItemStructure.all).then((item) => {
          // setState(() => {_item = item})
          print(item.title)
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("_item.title");
  }
}

class ItemStructure {
  final String by;
  final String title;
  final String type;
  final String url;
  final int descendants;
  final int score;
  final int time;
  final List<dynamic> kids;

  ItemStructure(
      {this.by,
      this.title,
      this.type,
      this.url,
      this.descendants,
      this.score,
      this.time,
      this.kids});
  factory ItemStructure.fromJson(Map<String, dynamic> json) {
    return ItemStructure(
        by: json['by'],
        title: json['title'],
        type: json['type'],
        url: json['url'],
        descendants: json['descendants'],
        score: json['score'],
        time: json['time'],
        kids: json['kids']);
  }

  static Resource<ItemStructure> get all {
    return Resource(
        url: "https://hacker-news.firebaseio.com/v0/item/8863.json",
        parse: (response) {
          final result = jsonDecode(response.body);
          return ItemStructure.fromJson(result);
        });
  }
}
