import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../favourite/controllers/favorites_controller.dart';
import '../screens/destination_detail_screen.dart';

class FavoriteButton extends StatelessWidget {
  final String destinationId;
  const FavoriteButton({super.key, required this.destinationId});

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();
    return Obx(() {
      final isFav = favorites.isFavoriteDestination(destinationId);
      return CircleIconButton(
        icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        iconColor: isFav ? Colors.redAccent : Colors.white,
        onTap: () => favorites.toggleDestination(destinationId),
      );
    });
  }
}