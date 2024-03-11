import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
            ),
            child: Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Centrer le contenu dans la colonne
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20.0), // Arrondir les angles de l'image
                    child: Image.asset(
                      'assets/images/default_image.jpeg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'PicTou',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // Gras
                      color: Colors.black, // Couleur du texte
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
