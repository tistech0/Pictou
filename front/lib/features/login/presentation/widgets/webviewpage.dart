import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  final baseUrl = dotenv.env['BASE_URL'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: WebView(
          initialUrl: '$baseUrl/auth/login/google',
          javascriptMode: JavascriptMode.unrestricted,
          userAgent: 'random',
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          onPageFinished: (String url) async {
            if (url.startsWith('$baseUrl/auth/callback/google')) {
              final jsonStr = await _controller.runJavascriptReturningResult(
                  "window.JSON.stringify(document.body.innerText);");
              final jsonString = jsonStr.trim().replaceAll('\\', '');
              final jsonStringGood = jsonString.substring(2, jsonString.length - 2);
              final decodedJson = json.decode(jsonStringGood);
              final connectedUser = UserEntity.fromJson(decodedJson);
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

