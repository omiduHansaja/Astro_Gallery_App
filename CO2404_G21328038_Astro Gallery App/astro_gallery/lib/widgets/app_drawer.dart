import 'package:flutter/material.dart';

import '../providers/theme_provider.dart';
import '../views/home_screen.dart';
import '../views/daily_image_screen.dart';
import '../views/search_screen.dart';
import '../views/favorites_screen.dart';
import '../views/settings_screen.dart';

//Class for the drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //Header section of the darwer
          DrawerHeader(
            //Background color
            decoration: BoxDecoration(color: Colors.indigo.shade800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Switches logo based on current theme mode
                ListenableBuilder(
                  listenable: themeProvider,
                  builder: (BuildContext context, Widget? child) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        themeProvider.isDark
                            ? "images/Astro Gallery App Logo(dark mode).png"
                            : "images/Astro Gallery App Logo(light mode).png",
                      ),
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),

                const SizedBox(height: 12),

                const Text(
                  "Astro Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  "Beyond Our World",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          //Navigate to Home screen
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pushReplacement(
                //Replace current screen
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),

          //Navigate to Daily Image screen
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text("Daily Image"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DailyImageScreen()),
              );
            },
          ),

          //Navigate to Search screen
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text("Search Library"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),

          //Navigate to Favourites screen
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favourites"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),

          //Navigate to Settings screen
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
