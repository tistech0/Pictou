import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google'),
      ),
      body: const WebView(
        initialUrl: 'http://localhost:8000/api/auth/login/google',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
