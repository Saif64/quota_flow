import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;
  final Random _random = Random();

  FavoritesScreen(this.favoriteQuotes, {super.key});

  /// Generates a random soft color for the background
  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(200) + 50, // Avoiding very dark colors
      _random.nextInt(200) + 50,
      _random.nextInt(200) + 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Quotes")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
          ),
          itemCount: favoriteQuotes.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRandomColor(), // Random background color
                borderRadius: BorderRadius.circular(12), // Smooth rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                favoriteQuotes[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
