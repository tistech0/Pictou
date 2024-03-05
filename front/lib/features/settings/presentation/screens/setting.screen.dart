import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/features/homepage/presentation/screens/homepage.screen.dart';
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
            primary: Colors.white,
            onPrimary: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.black,
            onPrimary: Colors.white,
          ),
        ),
        themeMode: Provider.of<ThemeProvider>(context).isDark ? ThemeMode.dark : ThemeMode.light,
        routes: {
          '/': (context) => const HomePage(),
          '/settings': (context) => const Settings(),
        },
      ),
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _pseudoController = TextEditingController();

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Changez votre pseudo:'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _pseudoController,
              decoration: const InputDecoration(
                labelText: 'Pseudo',
                border: OutlineInputBorder(),
                hintText: 'Entrez votre nouveau pseudo',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // Use the primary color of the current theme
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pseudo enregistré : ${_pseudoController.text}'),
                ),
              );
            },
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, // Use the primary color of the current theme
              ),
            ),
          ),
          SwitchListTile(
            title: Text('Mode sombre'),
            value: Provider.of<ThemeProvider>(context).isDark,
            onChanged: (bool value) {
              Provider.of<ThemeProvider>(context, listen: false).updateTheme();
            },
          ),
        ],
      ),
    );
  }
}
