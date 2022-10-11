class HomeAudio {
  HomeAudio({
    required this.musics,
  });

  Musics musics;

  factory HomeAudio.fromJson(Map<String, dynamic> json) => HomeAudio(
        musics: Musics.fromJson(json["musics"]),
      );

  Map<String, dynamic> toJson() => {
        "musics": musics.toJson(),
      };
}

class Musics {
  Musics({
    required this.artsit,
    required this.trackName,
    required this.trackImage,
    required this.urlMusic,
  });

  List<String> artsit;
  List<String> trackName;
  List<String> trackImage;
  List<String> urlMusic;

  factory Musics.fromJson(Map<String, dynamic> json) => Musics(
        artsit: List<String>.from(json["artsit"].map((x) => x)),
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        trackImage: List<String>.from(json["trackImage"].map((x) => x)),
        urlMusic: List<String>.from(json["urlMusic"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "artsit": List<dynamic>.from(artsit.map((x) => x)),
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "trackImage": List<dynamic>.from(trackImage.map((x) => x)),
        "urlMusic": List<dynamic>.from(urlMusic.map((x) => x)),
      };
}
