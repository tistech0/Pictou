import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/config/themeprovider.dart';
import 'package:front/core/config/userprovider.dart';

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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        // Assurez-vous que le contenu est scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Utilisateur: ${user.userId}'),
            Text('Email: ${user.email}'),
            // Afficher uniquement le refreshToken pour des raisons de sécurité peut être judicieux
            // Text('Access Token: ${user.accessToken}'),
            Text('Nom: ${user.name}'),
            Text('Prénom: ${user.givenName}'),
            SizedBox(height: 20),
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
                backgroundColor: Theme.of(context).colorScheme.secondary,
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            SwitchListTile(
              title: Text('Mode sombre'),
              value: Provider.of<ThemeProvider>(context).isDark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .updateTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
