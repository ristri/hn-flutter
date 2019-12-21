import 'package:flutter/material.dart';
import 'webservice.dart';
import 'dart:convert';

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

class Item extends StatefulWidget {
  final String title;

  Item({Key key, this.title}) : super(key: key);

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
    Webservice()
        .load(ItemStructure.all)
        .then((item) => {
              // setState(() => {_item = item})
              print(item.title)
            })
        .catchError((err) => print(err.toString()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("_item.title");
  }
}
