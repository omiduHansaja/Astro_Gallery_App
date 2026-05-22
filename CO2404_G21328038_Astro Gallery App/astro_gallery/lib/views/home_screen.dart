import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_drawer.dart';
import 'daily_image_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Astro Gallery"))),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Switches logo based on current theme mode
            ListenableBuilder(
              listenable: themeProvider,
              builder: (BuildContext context, Widget? child) {
                return Image.asset(
                  themeProvider.isDark
                      ? "images/Astro Gallery App Logo(dark mode).png"
                      : "images/Astro Gallery App Logo(light mode).png",
                  height: 180,
                );
              },
            ),

            const SizedBox(height: 30),

            //Button to navigate to the Astronomy Picture of the Day screen
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const DailyImageScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Astronomy Picture of the Day",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //Button to navigate to the NASA Photo and Video Library screen
            SizedBox(
              width: 280,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const SearchScreen(),
                    ),
                  );
                },
                child: const Text(
                  "NASA Photo and Video Library",
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
