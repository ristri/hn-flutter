import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  final String title;
  WebViewContainer({this.url, this.title});
  @override
  State<StatefulWidget> createState() => _WebViewContainerState(this.url, this.title);
}

class _WebViewContainerState extends State {
  var _url;
  var _title;
  final _key = UniqueKey();

  _WebViewContainerState(this._url, this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              key: _key,
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        ],
      ),
    );
  }
}
