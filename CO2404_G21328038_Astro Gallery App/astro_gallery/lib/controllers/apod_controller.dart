import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/apod_model.dart';

//Handles fetching data from the NASA APOD API
class ApodController {
  //Handles fetching of data from the API
  Future<ApodModel> fetchApod() async {
    //The API key is loaded from the .env file
    String apiKey = dotenv.get('NASA_API_KEY');

    //Sending a GET request to the APOD API
    var response = await http.get(
      Uri.parse("https://api.nasa.gov/planetary/apod?api_key=$apiKey"),
    );
    //Convert the response into the ApodModel and return it
    return ApodModel.fromJson(jsonDecode(response.body));
  }
}
