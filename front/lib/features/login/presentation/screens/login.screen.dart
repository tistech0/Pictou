import 'package:flutter/material.dart';
import 'package:front/core/domain/services/api_service.dart';
import 'package:front/features/login/presentation/widgets/webviewpage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/default_image.jpeg',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Welcome back on Pictou center',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WebViewPage()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
