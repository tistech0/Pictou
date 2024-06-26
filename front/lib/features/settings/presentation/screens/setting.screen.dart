import 'package:flutter/material.dart';
import 'package:front/features/login/presentation/screens/login.screen.dart';
import 'package:provider/provider.dart';
import 'package:front/core/config/themeprovider.dart';
import 'package:front/core/config/userprovider.dart';
// Assurez-vous d'avoir un écran de connexion pour rediriger l'utilisateur

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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              Text('ID Utilisateur: ${user.userId}'),
              Text('Email: ${user.email}'),
              Text('Nom: ${user.name}'),
              Text('Prénom: ${user.givenName}'),
              const SizedBox(height: 20),
            ],
            const Text('Changez votre pseudo :'),
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
              title: const Text('Mode sombre'),
              value: Provider.of<ThemeProvider>(context).isDark,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .updateTheme();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                userProvider.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}
