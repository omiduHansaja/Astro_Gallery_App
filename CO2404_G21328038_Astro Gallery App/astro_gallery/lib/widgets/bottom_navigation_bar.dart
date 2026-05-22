import 'package:flutter/material.dart';
import '../views/home_screen.dart';
import '../views/favorites_screen.dart';
import '../views/settings_screen.dart';

//Bottom navigation bar
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,

      onTap: (int index) {
        //Always navigate to home screen
        if (index == 0) {
          Navigator.pushAndRemoveUntil(
            //Clears the navigation routes
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (Route<dynamic> route) => false, //Remove previous routes
          );
          return;
        }
        //Favourites screen
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          );
        }

        //Settings screen
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => SettingsScreen()),
          );
        }
      },

      //Three icons showing each screen
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Favourites",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
