import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../favourite/services/favourite_services.dart';
import '../screens/destination_detail_screen.dart';

class FavoriteButton extends StatefulWidget {
  final String destinationId;
  const FavoriteButton({super.key, required this.destinationId});

  @override
  State<FavoriteButton> createState() => FavoriteButtonState();
}

class FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    final fav = await FavoritesService.isFavoriteDestination(uid, widget.destinationId);
    if (mounted) setState(() { _isFavorite = fav; _loading = false; });
  }

  Future<void> _toggle() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save favorites')),
      );
      return;
    }
    setState(() => _isFavorite = !_isFavorite);
    await FavoritesService.toggleFavoriteDestination(uid: uid, destinationId: widget.destinationId);
  }

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      iconColor: _isFavorite ? Colors.redAccent : Colors.white,
      onTap: _loading ? () {} : _toggle,
    );
  }
}