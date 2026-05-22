import 'package:flutter/material.dart';

import '../models/favourites_store.dart';
import '../widgets/bottom_navigation_bar.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String description;

  const ImageDetailScreen({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    //To keep track of the image if already saved
    final bool isFav = FavouritesStore.exists(imageUrl);

    //To keep track if dark mode is active
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Image Details"))),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Display the image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                imageUrl,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      //Show a broken image icon if the image fails to load
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

            const SizedBox(height: 15),

            //Displaying the title of the image
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            //Displaying the date of the image
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 12),

            //Displaying the description of the image
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            //A button to save the image to favourites
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (!isFav) {
                    FavouritesStore.add(
                      FavouriteItem(
                        title: title,
                        date: date,
                        url: imageUrl,
                        description: description,
                        isVideo: false,
                      ),
                    );
                  }
                },
                label: const Text(
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
