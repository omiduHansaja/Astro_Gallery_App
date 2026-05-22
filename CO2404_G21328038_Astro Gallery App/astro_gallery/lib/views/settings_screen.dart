import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_navigation_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //To Keep track if the dark mode is active
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    //Container color changes based on the theme
    final Color containerColor = isDark
        ? const Color(0xFF1E2A44)
        : Colors.indigo.shade50;

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Settings"))),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //Settings section
          Text(
            "Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          //ListenableBuilder rebuilds only when the theme changes
          ListenableBuilder(
            listenable: themeProvider,
            builder: (BuildContext context, Widget? child) {
              final bool isDarkMode = themeProvider.isDark;

              return Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  secondary: Icon(
                    isDarkMode
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: isDarkMode ? Colors.white : Colors.indigo.shade700,
                  ),
                  title: Text(
                    isDarkMode ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    isDarkMode
                        ? "Tap to switch to light theme"
                        : "Tap to switch to dark theme",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  value: isDarkMode,
                  onChanged: (_) => themeProvider.toggle(),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          //Displaying app information
          Text(
            "App Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(
                Icons.info_outline,
                color: isDark ? Colors.white : Colors.indigo.shade700,
              ),
              title: Text(
                "App Version",
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              subtitle: Text(
                "1.0.0",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          //Displaying the about section
          Text(
            "About",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "Astro Gallery is a modern space-themed application designed to explore astronomy content in an interactive and user-friendly way. The app provides visual media, detailed information, and allows users to organise their favourite discoveries.",
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
