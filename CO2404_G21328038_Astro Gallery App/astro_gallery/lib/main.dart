//G21328038 - Omidu
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'views/home_screen.dart';
import 'models/favourites_store.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Loads the API key from the .env file
  await dotenv.load(fileName: ".env");

  //Loads the items in favourites screen
  await FavouritesStore.loadFromLocal();

  //Load the saved theme
  await themeProvider.loadFromPrefs();

  //Start the app
  runApp(const AstroGalleryApp());
}

class AstroGalleryApp extends StatelessWidget {
  const AstroGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      //Listen for the theme changes
      listenable: themeProvider,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          //Use the current theme mode
          themeMode: themeProvider.themeMode,

          //Dark theme
          darkTheme: ThemeData(
            //Use Material Design 3
            useMaterial3: true,

            //Sets the mode to dark
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0B0F1A),

            //App bar theme
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF121829),
              foregroundColor: Colors.white,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            //Elevated button theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF121829),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  //Rounded corners
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            //Bottom navigation bar theme
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF121829),
              selectedItemColor: Color(0xFF4DA3FF),
              unselectedItemColor: Colors.white70,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            //Drawer theme
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFF0B0F1A),
            ),

            //Floating action button theme
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF1A3A5C),
              foregroundColor: Colors.white,
            ),

            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(const Color(0xFF4DA3FF)),
              trackColor: WidgetStateProperty.all(const Color(0xFF1A3A5C)),
            ),

            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              bodyMedium: TextStyle(fontSize: 16),
            ),
          ),

          //Light theme
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFFFFFF),

            appBarTheme: AppBarTheme(
              backgroundColor: Colors.indigo.shade500,
              foregroundColor: Colors.white,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.indigo.shade500,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFFF4F6FB),
            ),

            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo.shade500,
              foregroundColor: Colors.white,
            ),

            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.all(Colors.indigo.shade700),
              trackColor: WidgetStateProperty.all(Colors.indigo.shade100),
            ),

            // Text theme
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              bodyMedium: TextStyle(fontSize: 16),
            ),
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}
