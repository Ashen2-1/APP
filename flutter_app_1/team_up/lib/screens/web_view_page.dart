import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenUrlInWebView extends StatefulWidget {
  final String url;

  const OpenUrlInWebView({required this.url});

  @override
  _OpenUrlInWebViewState createState() => _OpenUrlInWebViewState();
}

class _OpenUrlInWebViewState extends State<OpenUrlInWebView> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          _openUrlInNewTab();
        },
      ),
    );
  }

  void _openUrlInNewTab() async {
    await _webViewController
        .evaluateJavascript('window.open("${widget.url}", "_blank");');
  }
}
