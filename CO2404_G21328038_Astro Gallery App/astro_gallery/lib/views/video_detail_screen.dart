import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../models/favourites_store.dart';
import '../widgets/bottom_navigation_bar.dart';

class VideoDetailScreen extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String date;
  final String description;

  const VideoDetailScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.date,
    required this.description,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  //Controls video playback
  VideoPlayerController? _controller;
  bool isLoading = true; //Keeps track if the loading icon is displayed
  bool hasError = false; //Keeps track if an error message is shown

  @override
  void initState() {
    super.initState();
    fetchAndInitVideo();
  }

  // Get the thumbnail and the asset ID to play the video
  Future<void> fetchAndInitVideo() async {
    try {
      //Split the thumbnail to get the asset ID
      final List<String> parts = widget.videoUrl.split("/");
      //Assest ID is always at index 4
      final String assetId = parts[4];

      //Call the NASA asset endpoint to get all files for this video
      final http.Response response = await http.get(
        Uri.parse("https://images-api.nasa.gov/asset/$assetId"),
      );

      //Show an error if the request was unsuccessfull
      if (response.statusCode != 200) {
        setState(() {
          hasError = true;
          isLoading = false; //Hide the loading icon
        });
        return;
      }

      //Decode the JSON response
      final Map<String, dynamic> jsonData =
          jsonDecode(response.body) as Map<String, dynamic>;

      //Get the list of files
      final List<dynamic> items =
          jsonData["collection"]["items"] as List<dynamic>;

      //Go through the files and find the first .mp4
      String? mp4Url;
      for (final dynamic item in items) {
        final String href = item["href"] as String;
        if (href.endsWith(".mp4")) {
          mp4Url = href.replaceFirst("http://", "https://");
          break;
        }
      }

      //Show an error if no .mp4 file was found
      if (mp4Url == null) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
        return;
      }

      //Initialise the video player with the real .mp4 URL
      _controller = VideoPlayerController.networkUrl(Uri.parse(mp4Url))
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        });
    } catch (e) {
      //Show an error if anything goes wrong
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  //Removing the controller when leaving the screen to free up memory
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFav = FavouritesStore.exists(
      widget.videoUrl,
    ); //Checks if the video is already added to the favourites list
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Video Details"))),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Video player in a rounded cornered container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),

              clipBehavior: Clip.hardEdge,
              child: AspectRatio(
                aspectRatio: 16 / 9, //Fix the video to a 16:9 ratio
                child: Container(
                  color: Colors.black,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : hasError
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Icon to display if video is unavailable
                              Icon(
                                Icons.videocam_off,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Video unavailable",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : _controller!.value.isInitialized
                      ? VideoPlayer(
                          _controller!,
                        ) 
                        //Show the video player when ready
                      : const Center(
                          child: CircularProgressIndicator(),
                        ), 
                        //Loading icon is displayed while loading
                ),
              ),
            ),

            const SizedBox(height: 10),

            //Only show play/pause once the video is ready
            if (!isLoading && !hasError && _controller != null)
              Center(
                child: IconButton(
                  icon: Icon(
                    _controller!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    size: 60,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!
                                .pause() //Pause the video
                          : _controller!.play(); //Play the video
                    });
                  },
                ),
              ),

            const SizedBox(height: 15),

            //Display the title of the video
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            //Display the date of the video
            Text(
              widget.date,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 12),

            //Display the description of the video
            Text(
              widget.description,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            //A button to add the video to the favourites screen
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  if (!isFav) {
                    FavouritesStore.add(
                      FavouriteItem(
                        title: widget.title,
                        date: widget.date,
                        url: widget.videoUrl,
                        description: widget.description,
                        isVideo: true,
                      ),
                    );
                    setState(() {});
                  }
                },
                child: const Text(
                  "Add to favourites",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
