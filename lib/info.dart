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
    required this.musicUrl,
    required this.name,
  });

  List<String> artsit;
  List<String> trackName;
  List<String> trackImage;
  List<String> musicUrl;
  int name;

  factory Musics.fromJson(Map<String, dynamic> json) => Musics(
        artsit: List<String>.from(json["artist"].map((x) => x)),
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        trackImage: List<String>.from(json["trackImage"].map((x) => x)),
        musicUrl: List<String>.from(json["musicUrl"].map((x) => x)),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "artist": List<dynamic>.from(artsit.map((x) => x)),
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "trackImage": List<dynamic>.from(trackImage.map((x) => x)),
        "musicUrl": List<dynamic>.from(musicUrl.map((x) => x)),
        "name": name,
      };
}

class TrackNameAdd {
  List<String> trackName;
  int name;
    TrackNameAdd({
    required this.trackName,
    required this.name,
  });
  factory TrackNameAdd.fromJson(Map<String, dynamic> json) => TrackNameAdd(  
        trackName: List<String>.from(json["trackName"].map((x) => x)),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "trackName": List<dynamic>.from(trackName.map((x) => x)),
        "name": name,
      };
}
