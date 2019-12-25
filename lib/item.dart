import 'package:flutter/material.dart';
import 'webservice.dart';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

class CommentStructure {
  final int id;
  final int level;
  final String user;
  final int time;
  final String timeAgo;
  final String content;
  final List<CommentStructure> comments;
  CommentStructure(
      {this.id,
      this.level,
      this.user,
      this.time,
      this.timeAgo,
      this.content,
      this.comments});
  factory CommentStructure.fromJson(Map<String, dynamic> json) {
    return CommentStructure(
        id: json['id'] ?? 0,
        level: json['level'] ?? 0,
        user: json['user'] ?? "",
        time: json['time'] ?? 0,
        timeAgo: json['time_ago'] ?? "",
        content: json['content'] ?? "",
        comments: json['comments'] != null
            ? (json['comments'] as List)
                .map((comment) => CommentStructure.fromJson(comment))
                .toList()
            : []);
  }
}

class ItemStructure {
  final String type;
  final String title;
  final String user;
  final String timeAgo;
  final String content;
  final String url;
  final int id;
  final int points;
  final int time;
  final List<CommentStructure> comments;

  ItemStructure(
      {this.type,
      this.title,
      this.user,
      this.url,
      this.timeAgo,
      this.content,
      this.points,
      this.id,
      this.time,
      this.comments});
  factory ItemStructure.fromJson(Map<String, dynamic> json) {
    return ItemStructure(
        type: json['type'] ?? "",
        title: json['title'] ?? "",
        user: json['user'] ?? "",
        url: json['url'] ?? "",
        timeAgo: json['time_ago'] ?? "",
        content: json['content'] ?? "",
        id: json['id'] ?? 0,
        points: json['points'] ?? 0,
        time: json['time'] ?? 0,
        comments: json['comments'] != null
            ? (json['comments'] as List)
                .map((comment) => CommentStructure.fromJson(comment))
                .toList()
            : []);
  }

  static Resource<ItemStructure> all(int id) {
    return Resource(
        url: "https://api.hackerwebapp.com/item/" + id.toString(),
        parse: (response) {
          final result = jsonDecode(response.body);
          // debugPrint(result.toString());
          return ItemStructure.fromJson(result);
        });
  }
}

class Item extends StatefulWidget {
  final String title;
  final int id;

  Item({Key key, this.title, this.id}) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  ItemStructure _item;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _populateItem();
  }

  Widget _buildComments(List<CommentStructure> parentComments) {
    if (parentComments.length == 0) return Container();
    return Container(
      child: ListView.builder(
        itemCount: parentComments.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext ctxt, int index) {
          return Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 12.0 * parentComments[index].level),
                child: Container(
                  child: Html(data: parentComments[index].content),
                  decoration: BoxDecoration(border: Border.all()),
                ),
              ),
              _buildComments(parentComments[index].comments)
            ],
          );
        },
      ),
    );
  }

  void _populateItem() {
    setState(() {
      isLoading = true;
    });
    Webservice()
        .load(ItemStructure.all(widget.id))
        .then((item) => {
              setState(() => {_item = item, isLoading = false})
            })
        .catchError((err) => print(err.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(_item.title),
                  Html(data: _item.content),
                  Expanded(child: _buildComments(_item.comments))
                ],
              ),
            ),
    );
  }
}
