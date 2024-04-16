import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/features/_global/presentation/widgets/app_bar.widget.dart';
import 'package:front/features/home/presentation/widgets/refreshable_album_carousel.widget.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/userprovider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAlbums());
  }

  void _loadAlbums() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    if (userProvider.user?.accessToken != null) {
      albumProvider.fetchAlbums(userProvider.user!.accessToken!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Album',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RefreshableAlbumCarouselWidget(isShared: false),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Shared Album',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RefreshableAlbumCarouselWidget(isShared: true),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
