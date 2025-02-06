import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jokeModel.dart';

class JokeService {
  final String apiUrl = "https://v2.jokeapi.dev/joke/Any?type=twopart";

  Future<List<Joke>> fetchJokes() async {
    List<Joke> jokes = [];
    try {
      // Clear the cache at the start of fetching jokes
      await clearCache();

      for (int i = 0; i < 5; i++) {
        // Add randomness to ensure unique jokes
        final response = await http.get(
          Uri.parse("$apiUrl&timestamp=${DateTime.now().millisecondsSinceEpoch}"),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data["type"] == "twopart") {
            jokes.add(Joke(
              setup: data["setup"],
              punchline: data["delivery"],
            ));
          } else {
            throw Exception("Unexpected joke format");
          }
        } else {
          throw Exception("Failed to fetch joke");
        }
      }
      await saveJokesToCache(jokes); // Save jokes to cache
    } catch (e) {
      // If an error occurs, fetch jokes from cache
      jokes = await getJokesFromCache();
    }
    return jokes;
  }

  Future<void> saveJokesToCache(List<Joke> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = jokes.map((joke) => jsonEncode(joke.toJson())).toList();
    prefs.setStringList('cached_jokes', jokesJson); // Overwrites existing cache
  }

  Future<List<Joke>> getJokesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jokesJson = prefs.getStringList('cached_jokes') ?? [];
    return jokesJson.map((j) => Joke.fromJson(jsonDecode(j))).toList();
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_jokes'); // Clear the cache
  }
}
