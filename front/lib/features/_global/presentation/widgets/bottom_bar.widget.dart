import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  final VoidCallback onImportPressed;

  const BottomBarWidget({super.key, required this.onImportPressed});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
