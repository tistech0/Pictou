import 'package:flutter/material.dart';
import 'package:front/features/_global/presentation/widgets/import_pictures_dialog.widget.dart';
import 'package:front/features/_global/presentation/widgets/new_album_dialog.widget.dart';
import 'package:front/features/settings/presentation/screens/setting.screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton(
          icon: const Icon(Icons.add),
          offset: const Offset(55, 20),
          onSelected: (value) {
            switch (value) {
              case 'create_album':
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const NewAlbumDialog(),
                );
                break;
              case 'import_photos':
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const ImportPicturesDialog(),
                );
                break;
              default:
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 'create_album',
              child: Text('Créer un Album'),
            ),
            const PopupMenuItem(
              value: 'import_photos',
              child: Text('Importer des Photos'),
            ),
          ],
          color: Colors.white.withOpacity(0.9),
        ),
        title: const Text('PicTou'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
