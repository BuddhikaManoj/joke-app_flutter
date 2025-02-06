import 'dart:ui'; // Required for the BackdropFilter
import 'package:flutter/material.dart';
import '../services/jokeService.dart';
import '../models/jokeModel.dart';

class JokeScreen extends StatefulWidget {
  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  final JokeService jokeService = JokeService();
  List<Joke> jokes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadJokes();
  }

  Future<void> loadJokes() async {
    setState(() {
      isLoading = true;
    });
    jokes = await jokeService.fetchJokes(); // Fetch new jokes
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/bg.png', // Replace with your image asset path
            fit: BoxFit.cover,
          ),
          // Content Overlay
          Padding(
            padding: const EdgeInsets.only(top: 100.0), // Add top margin here
            child: Column(
              children: [
                // AppBar Text inside the body
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Let's Smile", // Your AppBar text here
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color for visibility
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: const Color.fromARGB(255, 118, 135, 164),
                          ),
                        )
                      : ListView.builder(
                          itemCount: jokes.length,
                          itemBuilder: (context, index) {
                            final joke = jokes[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 223, 223, 223).withOpacity(0.15), // Transparent white
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 138, 137, 137).withOpacity(0.2), // border
                                        width: 1.5,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        joke.setup,
                                        style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), // Text color for visibility
                                      ),
                                      subtitle: Text(
                                        " - "+joke.punchline,
                                        style: TextStyle(color: const Color.fromARGB(255, 196, 194, 194)), // Text color for visibility
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Refresh Button with Bottom Margin
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0), // Add bottom margin
                  child: ElevatedButton(
                    onPressed: loadJokes, // Calls the API when clicked
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 52, 147, 215),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "New Jokes",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
