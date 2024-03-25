import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Auth'),
      ),
      body: WebView(
        initialUrl:
            'http://localhost:8000/api/auth/login/google', // Mettez ici votre URL d'authentification Google
        javascriptMode: JavascriptMode.unrestricted,
        userAgent: 'random',
        navigationDelegate: (NavigationRequest request) {
          // Vérifiez si l'URL de redirection est atteinte
          if (request.url
              .startsWith('http://localhost:8000/api/auth/callback/google')) {
            print('ok');
            // L'URL de redirection est atteinte, vous pouvez maintenant extraire le token ou effectuer une autre action
            // Par exemple : extrayez le token d'authentification de l'URL
            final uri = Uri.parse(request.url);

            //get the body response
            //get request body reponse
            final token = uri.queryParameters['token'];
            print('Token: $token');

            // Enregistrez le token dans le stockage local ou effectuez une autre action

            // Fermez la WebView et retournez à une autre partie de votre application
            Navigator.of(context).pop();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
