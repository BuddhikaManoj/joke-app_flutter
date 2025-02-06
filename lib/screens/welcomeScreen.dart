import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'jokeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with WidgetsBindingObserver {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller
    _controller = VideoPlayerController.asset('assets/welcome.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play(); // Play the video as soon as it is initialized
      });

    // Add observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Dispose the controller when the screen is disposed
    WidgetsBinding.instance.removeObserver(this); // Remove observer when disposing
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // Reinitialize the video controller when the app is resumed
      if (!_controller.value.isInitialized) {
        _controller.initialize().then((_) {
          setState(() {});
          _controller.play();
        });
      } else {
        _controller.play(); // Ensure the video is playing after resume
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video
          _controller.value.isInitialized
              ? VideoPlayer(_controller) // Display the video
              : Center(child: CircularProgressIndicator(
                 color: const Color.fromARGB(255, 109, 129, 163), 
              )), // Show loading indicator until video is loaded
          // Content Overlay
          Column(
            mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 170.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to JokeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => JokeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                    backgroundColor: Color.fromARGB(255, 52, 147, 215),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Explore",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
