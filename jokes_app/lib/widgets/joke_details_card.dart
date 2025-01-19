import 'package:flutter/material.dart';
import '../models/joke_model.dart';
import '../tools/favorites_manager.dart';

class JokeDetailCard extends StatefulWidget {
  final Joke joke;

  const JokeDetailCard({super.key, required this.joke});

  @override
  State<JokeDetailCard> createState() => _JokeDetailCardState();
}

class _JokeDetailCardState extends State<JokeDetailCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoritesManager().isFavorite(widget.joke);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.joke.setup,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.joke.punchline,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      FavoritesManager().removeFromFavorites(widget.joke);
                    } else {
                      FavoritesManager().addToFavorites(widget.joke);
                    }
                    isFavorite = !isFavorite;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Added to favorites!'
                            : 'Removed from favorites!',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                label: Text(
                  isFavorite ? 'Unfavorite' : 'Favorite',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
