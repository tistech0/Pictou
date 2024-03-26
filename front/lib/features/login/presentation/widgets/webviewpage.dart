import 'package:flutter/material.dart';
import 'package:front/features/home/presentation/screens/homepage.screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Auth')),
      body: WebView(
        initialUrl: 'http://localhost:8000/api/auth/login/google',
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: 'random',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) async {
          if (url
              .startsWith('http://localhost:8000/api/auth/callback/google')) {
            final bodyHtml = await _controller
                .runJavascriptReturningResult('document.body.innerText;');
            _parseAndPrintUserDetails(bodyHtml);
            if (mounted) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
          }
        },
      ),
    );
  }

  void _parseAndPrintUserDetails(String bodyHtml) {
    final userDetails = _extractUserDetailsFromHtml(bodyHtml);
    userDetails.forEach((key, value) => print('$key: $value'));
  }

  Map<String, dynamic> _extractUserDetailsFromHtml(String bodyHtml) {
    final Map<String, RegExp> patterns = {
      'User ID': RegExp(r'"user_id":\s*"(.*?)"'),
      'Email': RegExp(r'"email":\s*"(.*?)"'),
      'Refresh Token': RegExp(r'"refresh_token":\s*"(.*?)"'),
      'Refresh Token Exp': RegExp(r'"refresh_token_exp":\s*"(.*?)"'),
      'Name': RegExp(r'"name":\s*"(.*?)"'),
      'Given Name': RegExp(r'"given_name":\s*"(.*?)"'),
      'Access Token': RegExp(r'"access_token":\s*"(.*?)"'),
      'Access Token Exp': RegExp(r'"access_token_exp":\s*"(.*?)"'),
    };

    return patterns.map((key, value) =>
        MapEntry(key, value.firstMatch(bodyHtml)?.group(1) ?? 'Not Found'));
  }
}
