import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'image_detail_screen.dart';
import 'video_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Controls the search bar input
  final SearchController _searchController = SearchController();

  //Default search query when the screen loads
  String query = "space";

  //Fetches images and videos from the NASA image and video library
  Future<List<dynamic>> fetchImages() async {
    //Send a GET request to the API
    final http.Response response = await http.get(
      //Search using the query
      Uri.parse('https://images-api.nasa.gov/search?q=$query'),
    );

    //Check if the request was successful
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          jsonDecode(response.body)
              as Map<String, dynamic>; //Decode the JSON response
      return jsonData["collection"]["items"]
          as List<dynamic>; //Return the list of items
    } else {
      //Show an error if fails to load
      throw Exception("Failed to load images");
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the current text theme
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Search Library"))),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),

      body: Column(
        children: [
          //Search Bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchBar(
              controller: _searchController,
              leading: const Icon(Icons.search),
              hintText: "Search space images or videos",
              onSubmitted: (String value) {
                setState(() {
                  query = value.isEmpty ? "space" : value;
                });
              },
            ),
          ),

          //Grid of images and videos
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchImages(),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                //Show a loading indicator when loading data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                //Show an error message if the API call fails
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
                          "Failed to load results.",
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 15),

                        //A button to retry
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                //Get the results of data
                final List<dynamic> images = snapshot.data!;

                //Display the resuslts in a 2-column grid
                return GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: images.map((dynamic item) {
                    //Skip items that dont have these
                    if (item["links"] == null ||
                        item["data"] == null ||
                        (item["links"] as List).isEmpty ||
                        (item["data"] as List).isEmpty) {
                      return const SizedBox();
                    }

                    final String mediaType =
                        item["data"][0]["media_type"] as String;
                    final String imageUrl = (item["links"][0]["href"] as String)
                        .replaceFirst("http://", "https://");
                    final String title =
                        item["data"][0]["title"] as String? ?? "No title";
                    final String date =
                        item["data"][0]["date_created"] as String? ?? "No date";
                    final String description =
                        item["data"][0]["description"] as String? ??
                        "No description";

                    //Navigate to the correct screen(image or video) detail screen when an item is tapped
                    return GestureDetector(
                      onTap: () {
                        //Navigate to image detail screen if the item is an image
                        if (mediaType == "image") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageDetailScreen(
                                imageUrl: imageUrl,
                                title: title,
                                date: date,
                                description: description,
                              ),
                            ),
                          );
                        }

                        //Navigate to video detail screen if the item is a video
                        if (mediaType == "video") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VideoDetailScreen(
                                videoUrl: imageUrl,
                                title: title,
                                date: date,
                                description: description,
                              ),
                            ),
                          );
                        }
                      },

                      //Displays the thumbnail
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        //Clip the image to rounded corners
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                //Show an icon if the thumbnail fails to load
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
