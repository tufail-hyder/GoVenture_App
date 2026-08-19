import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  const CardImage({required this.coverImage});

  final String coverImage;

  bool get _isNetwork => coverImage.startsWith('http://') || coverImage.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (coverImage.isEmpty) return _placeholder();

    if (_isNetwork) {
      return Image.network(
        coverImage,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
        progress == null ? child : _placeholder(loading: true),
        errorBuilder: (context, error, stackTrace) => _placeholder(broken: true),
      );
    }

    return Image.asset(
      coverImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(broken: true),
    );
  }

  Widget _placeholder({bool loading = false, bool broken = false}) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(broken ? Icons.broken_image_outlined : Icons.image_outlined, color: Colors.grey.shade500),
    );
  }
}