import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'webservice.dart';

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
  final String domain;

  PostStructure(
      {this.id,
      this.title,
      this.points,
      this.user,
      this.time,
      this.timeAgo,
      this.commentCount,
      this.type,
      this.url,
      this.domain});

  factory PostStructure.fromJson(Map<String, dynamic> json) {
    return PostStructure(
        id: json['id'],
        title: json['title'],
        points: json['points'],
        user: json['user'],
        time: json['time'],
        timeAgo: json['time_ago'],
        commentCount: json['comment_count'],
        type: json['type'],
        url: json['url'],
        domain: json['domain']);
  }
}

class PostListStucture {
  final List<PostStructure> posts;
  PostListStucture({this.posts});
  factory PostListStucture.fromJson(List<Map<String, dynamic>> json) {
    // List<PostStructure> tempPosts = [];
    // json.forEach((post) => {
    //       tempPosts = [...tempPosts, PostStructure.fromJson(post)]
    //     });
    // return PostListStucture(posts: tempPosts);
    return PostListStucture(
        posts: (json).map((post) => PostStructure.fromJson(post)).toList());
  }
  static Resource<PostListStucture> get all {
    return Resource(
        url: "https://api.hackerwebapp.com/news?page=1",
        parse: (response) {
          final result = jsonDecode(response.body);
          debugPrint(result.toString());
          return PostListStucture.fromJson(List.from(result));
        });
  }
}

class MainFetchData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainFetchState();
}

class _MainFetchState extends State<MainFetchData> {
  PostListStucture posts = PostListStucture(posts: []);
  var isLoading = false;

  _fetchData() {
    setState(() {
      isLoading = true;
    });

    Webservice().load(PostListStucture.all).then((PostListStucture list) {
      posts = list;
      setState(() => {isLoading = false});
    }).catchError((err) => {
          print(err.toString())
          // throw Exception(err)
        });

    // var response =
    //     await http.get("https://hacker-news.firebaseio.com/v0/topstories.json");
    // if (response.statusCode == 200) {
    //   list = List.from(jsonDecode(response.body)).sublist(0, 9);
    //   debugPrint(list.toString());
    //   for (var postId in list) {
    //     debugPrint(postId.toString());
    //     response = await http
    //         .get("https://hacker-news.firebaseio.com/v0/item/$postId.json");
    //     if (response.statusCode == 200) {
    //       Map post = jsonDecode(response.body);
    //       debugPrint(post.toString());
    //       posts = [...posts, post];
    //     }
    //     // Display items as they are loaded one by one
    //     // setState(() {
    //     //   isLoading = false;
    //     // });
    //   }
    //   debugPrint(posts.toString());
    //   // final data = await http.get("https://hacker-news.firebaseio.com/v0/item/8863.json");
    //   setState(() {
    //     isLoading = false;
    //   });
    // } else {
    //   throw Exception("Failed to load photos");
    // }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception("Can't open url " + url);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
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
              itemBuilder: (BuildContext context, int index) => ListTile(
                contentPadding: EdgeInsets.all(5.0),
                title: Text(allPosts[index].title.toString()),
                subtitle: Text("By: " +
                    allPosts[index].user +
                    ", " +
                    allPosts[index].commentCount.toString() +
                    " comments"),
                leading: Text("${index + 1}"),
                trailing: Icon(Icons.open_in_new),
                onTap: () => _launchURL(allPosts[index].url),
              ),
            ),
    );
  }
}
