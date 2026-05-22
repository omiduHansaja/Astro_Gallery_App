import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/nasa_library_model.dart';

//Handles fetching data from the NASA Image and Video Library API
class NasaLibraryController {
  //Fetches a list of space images and videos from the API
  Future<List<NasaMedia>> fetchMedia() async {
    //Sending a GET request to the API
    var response = await http.get(
      Uri.parse("https://images-api.nasa.gov/search?q=space"),
    );

    //Decode the JSON response
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    //Get the list of items from the response
    List items = jsonData["collection"]["items"];

    //Creating an emtpy list to store the results
    List<NasaMedia> mediaList = [];

    //Loop through each item in the list
    for (var item in items) {
      mediaList.add(NasaMedia.fromJson(item));
    }

    return mediaList;
  }
}
