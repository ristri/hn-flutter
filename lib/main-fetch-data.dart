import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainFetchData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainFetchState();
}

class _MainFetchState extends State<MainFetchData> {
  List list = List();
  var isLoading = false;
  List posts = [];

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    var response =
        await http.get("https://hacker-news.firebaseio.com/v0/topstories.json");
    if (response.statusCode == 200) {
      list = List.from(jsonDecode(response.body)).sublist(0, 9);
      debugPrint(list.toString());
      for (var postId in list) {
        debugPrint(postId.toString());
        response = await http
            .get("https://hacker-news.firebaseio.com/v0/item/$postId.json");
        if (response.statusCode == 200) {
          Map post = jsonDecode(response.body);
          debugPrint(post.toString());
          posts = [...posts, post];
        }
        // Display items as they are loaded one by one
        // setState(() {
        //   isLoading = false;
        // });
      }
      debugPrint(posts.toString());
      // final data = await http.get("https://hacker-news.firebaseio.com/v0/item/8863.json");
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load photos");
    }
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
    return Scaffold(
      appBar: AppBar(title: Text("HackerNews")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                contentPadding: EdgeInsets.all(5.0),
                title: Text(posts[index]['title'].toString()),
                subtitle: Text("By: " +
                    posts[index]['by'] +
                    ", " +
                    posts[index]['descendants'].toString() +
                    " comments"),
                leading: Text("${index + 1}"),
                trailing: Icon(Icons.open_in_new),
                onTap: () => _launchURL(posts[index]['url']),
              ),
            ),
    );
  }
}
