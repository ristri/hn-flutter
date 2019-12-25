import 'dart:convert';
import 'package:flutter/material.dart';
import 'web-view.dart';
import 'webservice.dart';
import 'item.dart';

class PostStructure {
  final int id;
  final String title;
  final int points;
  final String user;
  final int time;
  final String timeAgo;
  final int commentCount;
  final String type;
  final String url;

  PostStructure(
      {this.id,
      this.title,
      this.points,
      this.user,
      this.time,
      this.timeAgo,
      this.commentCount,
      this.type,
      this.url});

  factory PostStructure.fromJson(Map<String, dynamic> json) {
    return PostStructure(
          id: json['id'] ?? 0,
          title: json['title'] ?? "",
          points: json['points'] ?? 0,
          user: json['user'] ?? "",
          time: json['time'] ?? 0,
          timeAgo: json['time_ago'] ?? "",
          commentCount: json['comment_count'] ?? 0,
          type: json['type'] ?? "",
          url: json['url'],
        ) ??
        "";
  }
}

class PostListStucture {
  List<PostStructure> posts;
  PostListStucture({this.posts});
  factory PostListStucture.fromJson(List<Map<String, dynamic>> json) {
    return PostListStucture(
        posts: (json).map((post) => PostStructure.fromJson(post)).toList());
  }
  static Resource<PostListStucture> all(int page) {
    return Resource(
        url: "https://api.hackerwebapp.com/news?page=$page",
        parse: (response) {
          final result = jsonDecode(response.body);
          // debugPrint(result.toString());
          return PostListStucture.fromJson(List.from(result));
        });
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PostListStucture posts = PostListStucture(posts: []);
  bool isLoading = false;
  ScrollController _controller;
  int page = 1;

  _fetchData(int page) {
    setState(() {
      isLoading = true;
    });

    Webservice().load(PostListStucture.all(page)).then((PostListStucture list) {
      posts.posts = [...posts.posts, ...list.posts];
      setState(() => {isLoading = false});
    }).catchError((err) => {
          print(err.toString())
          // throw Exception(err)
        });
  }

  _launchURL(BuildContext context, String url, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewContainer(
                  url: url,
                  title: title,
                )));
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      debugPrint("reached at end of list view");
      this.page++;
      _fetchData(this.page);
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _fetchData(this.page);
  }

  @override
  Widget build(BuildContext context) {
    final List<PostStructure> allPosts = posts.posts;
    return Scaffold(
      appBar: AppBar(title: Text("HackerNews")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allPosts.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) => ListTile(
                contentPadding: EdgeInsets.all(5.0),
                title: Text(allPosts[index].title.toString()),
                subtitle: Text("By: " + allPosts[index].user),
                leading: Text("${index + 1}"),
                trailing: InkResponse(
                  child: Icon(Icons.open_in_new),
                  onTap: () => _launchURL(
                      context, allPosts[index].url, allPosts[index].title),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Item(
                              id: allPosts[index].id,
                              title: allPosts[index].title,
                            ))),
              ),
            ),
    );
  }
}
