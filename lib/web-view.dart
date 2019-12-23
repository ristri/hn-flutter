import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  WebViewContainer({this.url});
  @override
  State<StatefulWidget> createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State {
  var _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("web view Route"),
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
