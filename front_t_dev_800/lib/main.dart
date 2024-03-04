import 'package:flutter/material.dart';
import 'package:front_t_dev_800/features/homepage/presentation/screens/homepage.screen.dart';
import 'package:front_t_dev_800/features/viewpictures/presentation/screens/viewpictures.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/pictures': (context) => const ViewPictures(),
      },
    );
  }
}
