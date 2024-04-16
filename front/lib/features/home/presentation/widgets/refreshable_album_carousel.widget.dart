import 'package:flutter/material.dart';
import 'package:front/core/config/albumprovider.dart';
import 'package:front/core/config/userprovider.dart';
import 'package:front/features/home/presentation/widgets/triple_view_container.widget.dart';
import 'package:provider/provider.dart';

class RefreshableAlbumCarouselWidget extends StatefulWidget {
  final bool isShared;
  const RefreshableAlbumCarouselWidget({super.key, required this.isShared});

  @override
  State<RefreshableAlbumCarouselWidget> createState() =>
      _RefreshableAlbumCarouselWidgetState();
}

class _RefreshableAlbumCarouselWidgetState
    extends State<RefreshableAlbumCarouselWidget> {
  Future<void> _refreshData() async {
    void loadAlbums() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
      if (userProvider.user?.accessToken != null) {
        albumProvider.fetchAlbums(userProvider.user!.accessToken!);
      }
    }

    loadAlbums();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            AlbumCarouselWidget(isShared: widget.isShared),
          ],
        ),
      ),
    );
  }
}
