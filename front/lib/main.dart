import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/homepage/presentation/screens/homepage.screen.dart';
import 'package:front/features/viewpictures/presentation/screens/viewpictures.screen.dart';
import 'package:front/core/config/themeprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlbumProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add this line
      ],
      child: Consumer<ThemeProvider>(
        // Use Consumer to access ThemeProvider
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: const ColorScheme.light(
                  primary: Colors.white,
                  onPrimary: Colors.black54,
                  secondary: Colors.grey),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: const ColorScheme.dark(
                background: Color(0xFF070F2B),
                primary: Color(0xFF1B1A55),
                onPrimary: Color(0xFF9290C3),
                secondary: Color(0xFF535C91),
              ),
            ),
            themeMode: themeProvider.isDark
                ? ThemeMode.dark
                : ThemeMode.light, // Use themeProvider to access isDark
            routes: {
              '/': (context) => const HomePage(),
              '/view-picture': (context) => const ViewPictures(
                    albumId: '',
                  ),
            },
          );
        },
      ),
    );
  }
}
