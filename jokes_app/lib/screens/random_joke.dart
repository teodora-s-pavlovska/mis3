import 'package:flutter/material.dart';
import '../models/joke_model.dart';
import '../tools/favorites_manager.dart';
import '../services/joke_service.dart';

class RandomJokeScreen extends StatefulWidget {
  const RandomJokeScreen({super.key});

  @override
  RandomJokeScreenState createState() => RandomJokeScreenState();
}

class RandomJokeScreenState extends State<RandomJokeScreen> {
  Joke? joke;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchRandomJoke();
  }

  Future<void> _fetchRandomJoke() async {
    final fetchedJoke = await ApiService.fetchRandomJoke();
    setState(() {
      joke = fetchedJoke;
      isFavorite = FavoritesManager().isFavorite(fetchedJoke);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Joke'),
        backgroundColor: Colors.blueAccent,
      ),
      body: joke == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    joke!.setup,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    joke!.punchline,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (isFavorite) {
                          FavoritesManager().removeFromFavorites(joke!);
                        } else {
                          FavoritesManager().addToFavorites(joke!);
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
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    label: Text(isFavorite ? 'Unfavorite' : 'Favorite'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchRandomJoke,
                    child: const Text('Get Another Joke'),
                  ),
                ],
              ),
            ),
    );
  }
}
