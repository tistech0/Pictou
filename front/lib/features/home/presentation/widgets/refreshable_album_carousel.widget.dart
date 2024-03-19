import 'package:flutter/material.dart';
import 'package:front/features/home/presentation/widgets/triple_view_container.widget.dart';

class RefreshableAlbumCarouselWidget extends StatefulWidget {
  const RefreshableAlbumCarouselWidget({super.key});

  @override
  State<RefreshableAlbumCarouselWidget> createState() =>
      _RefreshableAlbumCarouselWidgetState();
}

class _RefreshableAlbumCarouselWidgetState
    extends State<RefreshableAlbumCarouselWidget> {
  Future<void> _refreshData() async {
    // Ici, ajoutez votre logique pour rafraîchir les données
    // Par exemple, vous pourriez appeler setState() pour mettre à jour l'interface utilisateur
    // après avoir récupéré les nouvelles données.
    await Future.delayed(Duration(seconds: 1));

    // Simuler un chargement de données
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: _refreshData,
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            AlbumCarouselWidget(),
          ],
        ),
      ),
    );
  }
}
