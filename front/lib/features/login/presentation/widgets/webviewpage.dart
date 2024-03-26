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
      appBar: AppBar(
        title: const Text('Google Auth'),
      ),
      body: WebView(
        initialUrl: 'http://localhost:8000/api/auth/login/google',
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: 'random',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) async {
          //if url == callback google
          if (url
              .startsWith('http://localhost:8000/api/auth/callback/google')) {
            final String bodyHtml = await _controller
                .runJavascriptReturningResult('document.body.innerHTML;');
            //print 'token' on body response

            print(bodyHtml);
            //pop on homepage
            Navigator.of(context).pop(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
      ),
    );
  }
}
