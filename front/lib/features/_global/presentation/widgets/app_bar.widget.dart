import 'package:flutter/material.dart';
import 'package:front/features/_global/presentation/widgets/import_pictures_dialog.widget.dart';
import 'package:front/features/_global/presentation/widgets/new_album_dialog.widget.dart';
import 'package:front/features/settings/presentation/screens/setting.screen.dart';
import 'package:front/features/search/screens/viewPictureSearch.screen.dart';
import 'package:pictouapi/pictouapi.dart';
import 'package:provider/provider.dart';
import 'package:pictouapi/src/model/images_meta_data.dart';

import '../../../../core/config/userprovider.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSubmit;

  SearchBar({required this.onSubmit});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Enter tags',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            widget.onSubmit(_controller.text);
            _controller.clear();
          },
        ),
      ),
    );
  }
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final imageApi = Pictouapi().getImagesApi();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Search'),
                  content: SearchBar(
                    onSubmit: (String tags) async {
                      print(tags);
                      final response = await imageApi.getImages(
                        limit: 100,
                        offset: 0,
                        tags: tags,
                        headers: {
                          'Authorization': 'Bearer ${userProvider.user!.accessToken}',
                        },
                      );
                      if (response.statusCode == 200) {
                        final ImagesMetaData imagesMetaData = response.data!;
                        final imageIds = imagesMetaData.images.map((e) => e.id).toList();
                        print(imageIds);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPicturesSearchScreen(imageIds: imageIds)));
                      } else {
                        print(response.statusMessage);
                      }
                    },
                  ),
                ),
              );
            },
          ),
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
