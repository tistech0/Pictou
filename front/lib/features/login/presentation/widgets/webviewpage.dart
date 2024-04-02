import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/home/presentation/screens/homepage.screen.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:front/core/domain/entities/user.entity.dart';

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
        title: const Text('Login'),
      ),
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
              final jsonStr = await _controller.runJavascriptReturningResult(
                  "window.JSON.stringify(document.body.innerText);");
              final jsonString = jsonStr
                  .substring(1, jsonStr.length - 1)
                  .replaceAll(r'\"', '"');

              final decodedJson = json.decode(jsonString);

              final correctJson = json.encode(decodedJson);
              final jsonData = json.decode(correctJson);
              print(jsonData);
              final connectedUser = UserEntity.fromJson(jsonData);
              print(connectedUser);
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(connectedUser);

              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            }
          }),
    );
  }
}
