import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'import_pictures_dialog.widget.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    void openCamera() async {
      final ImagePicker pickerCamera = ImagePicker();
      final XFile? photo =
          await pickerCamera.pickImage(source: ImageSource.camera);
    }

    void openGallery() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    }

    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'importFromGallery':
                  openGallery();
                  break;
                case 'useCamera':
                  openCamera();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'importFromGallery',
                child: Center(
                  child: Text(
                    'Importer de la galerie',
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 'useCamera',
                child: Center(child: Text('Utiliser la caméra')),
              ),
            ],
            icon: const Icon(Icons.add_a_photo),
            offset: Offset(screenWidth / 4, 20),
          ),
        ],
      ),
    );
  }
}
