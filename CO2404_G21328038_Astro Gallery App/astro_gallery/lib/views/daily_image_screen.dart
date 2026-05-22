import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../models/favourites_store.dart';

class DailyImageScreen extends StatelessWidget {
  const DailyImageScreen({super.key});

  //Fetches the APOD From APOD API
  Future<Map<String, dynamic>> fetchApod() async {
    final String apiKey = dotenv.get('NASA_API_KEY');

    //Get the API key from the .env file
    final http.Response response = await http.get(
      //&date=2026-03-04 - Use this as an alternative if the API does not work
      Uri.parse("https://api.nasa.gov/planetary/apod?api_key=$apiKey"),
    );
    //Decode and return the JSON response
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    //Checks if dark mode is active
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Daily Image"))),
      drawer: const AppDrawer(),

      //Bottom navigation bar with Home tab selected
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),

      //Futurebuilder handles loading, error and states
      body: FutureBuilder<Map<String, dynamic>>(
        //Calls the APOD fetch function
        future: fetchApod(),
        builder:
            (
              BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot,
            ) {
              //Shows a circular loading indicator that shows waiting for the API response
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              //Shows an error message if the API call fails
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Failed to load data.",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),

                      //Elevated button to retry
                      ElevatedButton(
                        onPressed: () {
                          (context as Element).markNeedsBuild();
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              //Get the API response
              final Map<String, dynamic> data = snapshot.data!;

              //Checks if already saved
              final bool isFav = FavouritesStore.exists(data["url"] as String);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Displays title
                    Text(
                      data["title"] as String,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    //Displays date
                    Text(
                      data["date"] as String,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 12),

                    //Only display if its an image
                    if (data["media_type"] == "image")
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: AspectRatio(
                          //Fix the image ratio to a 16:9
                          aspectRatio: 16 / 9,
                          //Loads the image from the URL
                          child: Image.network(
                            data["url"] as String,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  BuildContext context,
                                  Object error,
                                  StackTrace? stackTrace,
                                ) {
                                  //Shows a icon if the image fails to load
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    //Displays the explanation
                    Text(
                      data["explanation"] as String,
                      style: TextStyle(
                        fontSize: 16,
                        //Text color based on color theme
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    //Button to save the current picture to favourites
                    SizedBox(
                      //Full width button
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //Only add if not already saved
                          if (!isFav) {
                            FavouritesStore.add(
                              FavouriteItem(
                                title: data["title"] as String,
                                date: data["date"] as String,
                                url: data["url"] as String,
                                description: data["explanation"] as String,
                                isVideo: false, // To keep track if its a video
                              ),
                            );
                          }
                        },
                        label: const Text(
                          "Add to favourites",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
      ),
    );
  }
}
