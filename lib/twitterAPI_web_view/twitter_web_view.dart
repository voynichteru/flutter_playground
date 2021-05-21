import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterWebView extends StatefulWidget {
  TwitterWebView(this.url);
  String url;
  @override
  State<StatefulWidget> createState() => _TwitterWebViewState();
}

class _TwitterWebViewState extends State<TwitterWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
