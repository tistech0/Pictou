import 'package:flutter/material.dart';
import 'package:front/core/config/themeprovider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

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
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .secondary, // Use the primary color of the current theme
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Pseudo enregistré : ${_pseudoController.text}'),
                ),
              );
            },
            child: Text(
              'Enregistrer',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary, // Use the primary color of the current theme
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
