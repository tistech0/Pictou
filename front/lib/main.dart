import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/homepage/presentation/screens/homepage.screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => const HomePage(),
        },
      ),
    );
  }
}
