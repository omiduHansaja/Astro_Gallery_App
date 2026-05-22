//Model for a data item from NASA images and Video Library API
class NasaMedia {
  String imageUrl; //Thumbnail URL of the image or video
  String title;
  String date;
  String description;
  String mediaType;

  NasaMedia({
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.description,
    required this.mediaType,
  });

  factory NasaMedia.fromJson(Map<String, dynamic> json) {
    return NasaMedia(
      imageUrl: json["links"][0]["href"],
      title: json["data"][0]["title"],
      date: json["data"][0]["date_created"],
      description: json["data"][0]["description"],
      mediaType: json["data"][0]["media_type"],
    );
  }
}
