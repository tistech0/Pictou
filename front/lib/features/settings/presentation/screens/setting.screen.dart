import 'package:flutter/material.dart';

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
            onPressed: () {
              // Logique pour enregistrer ou traiter le nouveau pseudo
              // Par exemple, afficher un message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Pseudo enregistré : ${_pseudoController.text}'),
                ),
              );
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
