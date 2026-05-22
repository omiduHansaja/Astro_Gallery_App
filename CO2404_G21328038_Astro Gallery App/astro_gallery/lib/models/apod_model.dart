//Model for the NASA APOD API response
class ApodModel {
  String title;
  String date;
  String explanation;
  String url;
  String mediaType;

  //Constructor
  ApodModel({
    required this.title,
    required this.date,
    required this.explanation,
    required this.url,
    required this.mediaType,
  });

  //Maps the JSON response fields to the properties
  factory ApodModel.fromJson(Map<String, dynamic> json) {
    return ApodModel(
      title: json["title"],
      date: json["date"],
      explanation: json["explanation"],
      url: json["url"],
      mediaType: json["media_type"],
    );
  }
}
