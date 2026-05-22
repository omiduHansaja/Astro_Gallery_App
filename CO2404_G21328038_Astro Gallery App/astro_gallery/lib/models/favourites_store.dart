import 'dart:convert';
//Used for local storage
import 'package:shared_preferences/shared_preferences.dart';

//Model to save a single item in favourites screen
class FavouriteItem {
  String title;
  String date;
  String url;
  String description;
  bool isVideo;

  FavouriteItem({
    required this.title,
    required this.date,
    required this.url,
    required this.description,
    required this.isVideo,
  });

  //Converts the item into a JSON format so it can be saved as a string
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'url': url,
      'description': description,
      'isVideo': isVideo,
    };
  }

  //Rebuilds an item from the saved JSON format
  factory FavouriteItem.fromJson(Map<String, dynamic> json) {
    return FavouriteItem(
      title: json['title'],
      date: json['date'],
      url: json['url'],
      description: json['description'],
      isVideo: json['isVideo'],
    );
  }
}

//Class that manages the favourites list
class FavouritesStore {
  static List<FavouriteItem> items = [];
  //Key used to store data in SharedPreferences
  static const String key = "favourites";

  //Returns true if an item already exists in the list
  static bool exists(String url) {
    return items.any((item) => item.url == url);
  }

  //Adds an item to the list only not stored in the list
  static Future<void> add(FavouriteItem item) async {
    if (!exists(item.url)) {
      items.add(item);
      await saveToLocal();
    }
  }

  //Removes an item from the list by its index
  static Future<void> remove(int index) async {
    items.removeAt(index);
    await saveToLocal();
  }

  //Saves the list to local storage
  static Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = items
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList(key, jsonList);
  }

  //Loads the items when the app starts
  static Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(key);

    if (jsonList != null) {
      items = jsonList
          .map((item) => FavouriteItem.fromJson(jsonDecode(item)))
          .toList();
    }
  }
}
