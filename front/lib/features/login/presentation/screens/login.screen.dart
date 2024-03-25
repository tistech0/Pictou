import 'package:flutter/material.dart';
import 'package:front/core/domain/services/api_service.dart';
import 'package:front/features/login/domain/use_cases/sign_in_with_google_use_case.dart';

class LoginScreen extends StatelessWidget {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  LoginScreen({super.key})
      : signInWithGoogleUseCase = SignInWithGoogleUseCase(ApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
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
              onPressed: () => signInWithGoogleUseCase.execute(context),
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
