import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oc_timka_gru_bmstu_music/info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: const MyStatefulWidget(),
    );
  }
}

//https://jtuto.com/flutter-how-to-handle-networkimage-with-invalid-image-data-exception/
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class MusicAdd {
  List<String> artist = [];
  List<String> musicUrl = [];
  List<String> trackName = [];
  List<String> trackImage = [];
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  final db_Mysics = FirebaseFirestore.instance;
  final db = FirebaseFirestore.instance;
  int lenghtMusic = 16;
  int? count;
  int? countMy;
  int? countMyMusic;
  MusicAdd musicAdd = MusicAdd();
  Map<String, dynamic>? infoMusic;
  Map<String, dynamic>? infoMyMusic;
  List<Map<String, String>> _allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];
  Map<String, dynamic> data = {};
  Map<String, dynamic> data_MY = {};
  bool active = false;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isMyPlaying = false;
  bool isAdd = true;
  Duration duration = Duration(seconds: 20);
  Duration position = Duration.zero;
  late TabController _tabController;
  int _selectedIndex = 0;
  List<String> bottomNavigationBar_ = ["Home", "Business"];

  void _onItemTapped(int index) {
    setState(() {
      _tabController.index = index;
      _selectedIndex = index;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      if (data.isNotEmpty) {
        for (int i = 0; i < lenghtMusic; i++) {
          if (_allUsers.length < 16) {
            _allUsers.add({
              "artist": data["musics"]["artist"][i],
              "musicUrl": data["musics"]["musicUrl"][i],
              "trackName": data["musics"]["trackName"][i],
              "trackImage": data["musics"]["trackImage"][i]
            });
          }
        }
        results = _allUsers;
      }
    } else {
      results = _allUsers
          .where((user) =>
              user["artist"]!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user["trackName"]!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      _foundUsers.clear();
      _foundUsers = results;
      print(_foundUsers);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: bottomNavigationBar_.length);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  addUser() {
    final docRef = db_Mysics.collection("user").doc("My musics");
    bool time = false;
    docRef.get().then((DocumentSnapshot doc) {
      data_MY = doc.data() as Map<String, dynamic>;
    }, onError: (e) => print("Error getting document: $e"));
    if (data_MY.isEmpty) {
      if (musicAdd.musicUrl.isEmpty) {
        musicAdd.artist.add(data["musics"]["artist"][count]);
        musicAdd.trackName.add(data["musics"]["trackName"][count]);
        musicAdd.trackImage.add(data["musics"]["trackImage"][count]);
        musicAdd.musicUrl.add(data["musics"]["musicUrl"][count]);
        final my = Musics(
          artsit: musicAdd.artist,
          trackName: musicAdd.trackName,
          trackImage: musicAdd.trackImage,
          musicUrl: musicAdd.musicUrl,
          name: musicAdd.musicUrl.length,
        );
        final home = HomeAudio(musics: my);
        final docRef = db
            .collection("user")
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  HomeAudio.fromJson(snapshot.data()!),
              toFirestore: (HomeAudio home, options) => home.toJson(),
            )
            .doc("My musics");
        docRef.set(home);
      }
    } else {
      musicAdd.artist.clear();
      musicAdd.musicUrl.clear();
      musicAdd.trackImage.clear();
      musicAdd.trackName.clear();
      print(data_MY);
      print(data_MY["musics"]["name"]);
      print(data_MY["musics"]["artist"]);
      for (int i = 0; i < data_MY["musics"]["name"]; i++) {
        musicAdd.artist.add(data_MY["musics"]["artist"][i]);
        musicAdd.trackName.add(data_MY["musics"]["trackName"][i]);
        musicAdd.trackImage.add(data_MY["musics"]["trackImage"][i]);
        musicAdd.musicUrl.add(data_MY["musics"]["musicUrl"][i]);
      }
      for (int i = 0; i < musicAdd.musicUrl.length; i++) {
        if (musicAdd.musicUrl[i] == data["musics"]["musicUrl"][count]) {
          time = true;
        }
      }
      if (!time) {
        musicAdd.artist.add(data["musics"]["artist"][count]);
        musicAdd.trackName.add(data["musics"]["trackName"][count]);
        musicAdd.trackImage.add(data["musics"]["trackImage"][count]);
        musicAdd.musicUrl.add(data["musics"]["musicUrl"][count]);
        final my = Musics(
          artsit: musicAdd.artist,
          trackName: musicAdd.trackName,
          trackImage: musicAdd.trackImage,
          musicUrl: musicAdd.musicUrl,
          name: musicAdd.musicUrl.length,
        );
        final home = HomeAudio(musics: my);
        final docRef = db
            .collection("user")
            .withConverter(
              fromFirestore: (snapshot, options) =>
                  HomeAudio.fromJson(snapshot.data()!),
              toFirestore: (HomeAudio home, options) => home.toJson(),
            )
            .doc("My musics");
        docRef.set(home);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<int> _stopwatch() async* {
    while (position.inSeconds != duration.inSeconds) {
      await Future.delayed(Duration(seconds: 1));
      yield position.inSeconds + 1;
      if (position.inSeconds == duration.inSeconds - 1) {
        if (count! + 1 != 16) {
          count = count! + 1;
          await audioPlayer.play(UrlSource(_foundUsers[count!]["musicUrl"]));
        } else {
          position = Duration(seconds: 0);
          audioPlayer.seek(position);
          audioPlayer.pause();
        }
      }
    }
  }

  Stream<int> _stopMywatch() async* {
    while (position.inSeconds != duration.inSeconds) {
      await Future.delayed(Duration(seconds: 1));
      yield position.inSeconds + 1;
      if (position.inSeconds == duration.inSeconds - 1) {
        if (countMy! + 1 != musicAdd.musicUrl.length) {
          countMy = countMy! + 1;
          await audioPlayer.play(UrlSource(musicAdd.musicUrl[countMy!]));
        } else {
          position = Duration(seconds: 0);
          audioPlayer.seek(position);
          audioPlayer.pause();
        }
      }
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          unselectedIconTheme: IconThemeData(
            color: Colors.black,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.airlines_sharp,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Search',
            ),
          ],
          selectedIconTheme: IconThemeData(color: Colors.deepPurple, size: 40),
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.white,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (_tabController.index == 0) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc('Musics')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.data() == null) {
                    return Center(child: Text("Users"));
                  } else {
                    data = snapshot.data!.data() as Map<String, dynamic>;
                    for (int i = 0; i < lenghtMusic; i++) {
                      if (_allUsers.length < 16) {
                        _allUsers.add({
                          "artist": data["musics"]["artist"][i],
                          "musicUrl": data["musics"]["musicUrl"][i],
                          "trackName": data["musics"]["trackName"][i],
                          "trackImage": data["musics"]["trackImage"][i]
                        });
                      }
                    }
                    if (_foundUsers.isEmpty) {
                      _foundUsers = _allUsers;
                    }
                  }
                }
                if (data.isEmpty) {
                  return Center(child: Text("Name"));
                } else {
                  return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(children: [
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          onChanged: (value) {
                            _runFilter(value);
                          },
                          decoration: const InputDecoration(
                              labelText: 'Search',
                              suffixIcon: Icon(Icons.search)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: _foundUsers.length,
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      key: ValueKey(
                                          _foundUsers[index]["artist"]),
                                      trailing: LayoutBuilder(
                                          builder: (context, constraints) {
                                        if (isPlaying && count == index) {
                                          return Icon(Icons.pause);
                                        } else {
                                          return Icon(Icons.play_arrow);
                                        }
                                      }),
                                      leading: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: 44,
                                            minHeight: 44,
                                            maxWidth: 64,
                                            minWidth: 64),
                                        child: Image.network(
                                          _foundUsers[index]["trackImage"],
                                        ),
                                      ),
                                      title: Text(
                                        _foundUsers[index]["artist"],
                                        textAlign: TextAlign.left,
                                      ),
                                      subtitle: Text(
                                        _foundUsers[index]["trackName"],
                                        textAlign: TextAlign.start,
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          count = index;
                                          isPlaying = true;
                                        });

                                        await audioPlayer.play(UrlSource(
                                            _foundUsers[count!]["musicUrl"]));

                                        print((formatTime(duration)));
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return StreamBuilder<int>(
                                                  stream: _stopwatch(),
                                                  builder: (context, snapshot) {
                                                    return FractionallySizedBox(
                                                      heightFactor: 0.8,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  Image.network(
                                                                _foundUsers[
                                                                        count!][
                                                                    "trackImage"],
                                                                width: 350,
                                                                height: 350,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 32,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 40),
                                                            child: ListTile(
                                                                title: Center(
                                                                  child: Text(
                                                                    _foundUsers[
                                                                            count!]
                                                                        [
                                                                        "artist"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                subtitle:
                                                                    Center(
                                                                  child: Text(
                                                                    _foundUsers[
                                                                            count!]
                                                                        [
                                                                        "trackName"],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          24,
                                                                    ),
                                                                  ),
                                                                ),
                                                                trailing: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return IconButton(
                                                                    icon: Icon(
                                                                      Icons.add,
                                                                    ),
                                                                    iconSize:
                                                                        20,
                                                                    onPressed:
                                                                        () {
                                                                      state(() {
                                                                        addUser();
                                                                      });
                                                                    },
                                                                  );
                                                                })),
                                                          ),
                                                          StatefulBuilder(
                                                              builder: (context,
                                                                  state) {
                                                            return Slider(
                                                                min: 0,
                                                                max: duration
                                                                    .inSeconds
                                                                    .toDouble(),
                                                                value: position
                                                                    .inSeconds
                                                                    .toDouble(),
                                                                onChanged:
                                                                    (value) {
                                                                  state(() {
                                                                    final position =
                                                                        Duration(
                                                                            seconds:
                                                                                value.toInt());
                                                                    print(formatTime(
                                                                        position));
                                                                    audioPlayer
                                                                        .seek(
                                                                            position);
                                                                    audioPlayer
                                                                        .resume();
                                                                  });
                                                                });
                                                          }),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(formatTime(
                                                                    position)),
                                                                Text(formatTime(
                                                                    duration -
                                                                        position)),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 40,
                                                                        right:
                                                                            15),
                                                                child: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return CircleAvatar(
                                                                    radius: 35,
                                                                    child: IconButton(
                                                                        icon: Icon(
                                                                          Icons
                                                                              .skip_previous_rounded,
                                                                        ),
                                                                        iconSize: 40,
                                                                        onPressed: () async {
                                                                          if (count !=
                                                                              0) {
                                                                            count =
                                                                                count! - 1;
                                                                            await audioPlayer.play(UrlSource(_foundUsers[count!]["musicUrl"]));
                                                                          } else {
                                                                            await audioPlayer.dispose();
                                                                            state(() {
                                                                              isPlaying = false;
                                                                            });
                                                                          }
                                                                        }),
                                                                  );
                                                                }),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 40,
                                                                ),
                                                                child: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return CircleAvatar(
                                                                    radius: 35,
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        isPlaying
                                                                            ? Icons.pause
                                                                            : Icons.play_arrow,
                                                                      ),
                                                                      iconSize:
                                                                          40,
                                                                      onPressed:
                                                                          () async {
                                                                        if (isPlaying) {
                                                                          state(
                                                                              () {
                                                                            isPlaying =
                                                                                false;
                                                                          });
                                                                          await audioPlayer
                                                                              .pause();
                                                                        } else {
                                                                          state(
                                                                              () {
                                                                            isPlaying =
                                                                                true;
                                                                          });
                                                                          await audioPlayer.play(UrlSource(_foundUsers[count!]
                                                                              [
                                                                              "musicUrl"]));
                                                                        }
                                                                      },
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 40,
                                                                        left:
                                                                            15),
                                                                child: StatefulBuilder(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return CircleAvatar(
                                                                    radius: 35,
                                                                    child: IconButton(
                                                                        icon: Icon(
                                                                          Icons
                                                                              .skip_next_rounded,
                                                                        ),
                                                                        iconSize: 40,
                                                                        onPressed: () async {
                                                                          if (count !=
                                                                              15) {
                                                                            count =
                                                                                count! + 1;
                                                                            await audioPlayer.play(UrlSource(_foundUsers[count!]["musicUrl"]));
                                                                          } else {
                                                                            await audioPlayer.dispose();
                                                                            state(() {
                                                                              isPlaying = false;
                                                                            });
                                                                          }
                                                                        }),
                                                                  );
                                                                }),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            });
                                      });
                                }))
                      ]));
                }
              },
            );
          } else {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc('My musics')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data?.data() == null) {
                    return Center(child: Text("Add Musics"));
                  } else {
                    data_MY = snapshot.data!.data() as Map<String, dynamic>;
                    musicAdd.artist.clear();
                    musicAdd.musicUrl.clear();
                    musicAdd.trackImage.clear();
                    musicAdd.trackName.clear();
                    print(data_MY);
                    print(data_MY["musics"]["name"]);
                    print(data_MY["musics"]["artist"]);
                    for (int i = 0; i < data_MY["musics"]["name"]; i++) {
                      musicAdd.artist.add(data_MY["musics"]["artist"][i]);
                      musicAdd.trackName.add(data_MY["musics"]["trackName"][i]);
                      musicAdd.trackImage
                          .add(data_MY["musics"]["trackImage"][i]);
                      musicAdd.musicUrl.add(data_MY["musics"]["musicUrl"][i]);
                    }
                  }
                }
                if (data.isEmpty) {
                  return Center(child: Text("Name"));
                } else {
                  return Scaffold(
                      appBar: AppBar(
                        title: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Page 1",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))),
                        backgroundColor: Colors.black87,
                      ),
                      body: ListView.builder(
                          itemCount: musicAdd.musicUrl.length,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (BuildContext context, int index) {
                            return new Dismissible(
                                background: Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 44,
                                        ),
                                        Text(
                                          "delete",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                                key: new UniqueKey(),
                                onDismissed: (direction) {
                                  musicAdd.artist.removeAt(index);
                                  musicAdd.musicUrl.removeAt(index);
                                  musicAdd.trackImage.removeAt(index);
                                  musicAdd.trackName.removeAt(index);
                                  final my = Musics(
                                    artsit: musicAdd.artist,
                                    trackName: musicAdd.trackName,
                                    trackImage: musicAdd.trackImage,
                                    musicUrl: musicAdd.musicUrl,
                                    name: musicAdd.musicUrl.length,
                                  );
                                  final home = HomeAudio(musics: my);
                                  final docRef = db
                                      .collection("user")
                                      .withConverter(
                                        fromFirestore: (snapshot, options) =>
                                            HomeAudio.fromJson(
                                                snapshot.data()!),
                                        toFirestore:
                                            (HomeAudio home, options) =>
                                                home.toJson(),
                                      )
                                      .doc("My musics");
                                  docRef.set(home);
                                },
                                child: ListTile(
                                    trailing: LayoutBuilder(
                                        builder: (context, constraints) {
                                      if (isMyPlaying && countMy == index) {
                                        return Icon(Icons.pause);
                                      } else {
                                        return Icon(Icons.play_arrow);
                                      }
                                    }),
                                    leading: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 44,
                                          minHeight: 44,
                                          maxWidth: 64,
                                          minWidth: 64),
                                      child: Image.network(
                                          musicAdd.trackImage[index]),
                                    ),
                                    title: Text(
                                      musicAdd.artist[index],
                                      textAlign: TextAlign.left,
                                    ),
                                    subtitle: Text(
                                      musicAdd.trackName[index],
                                      textAlign: TextAlign.start,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        countMy = index;

                                        isMyPlaying = true;
                                      });

                                      await audioPlayer.play(UrlSource(
                                          musicAdd.musicUrl[countMy!]));
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return StreamBuilder<int>(
                                                stream: _stopMywatch(),
                                                builder: (context, snapshot) {
                                                  return FractionallySizedBox(
                                                    heightFactor: 0.8,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              musicAdd.trackImage[
                                                                  countMy!],
                                                              width: 350,
                                                              height: 350,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 32,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 40),
                                                          child: ListTile(
                                                              title: Center(
                                                                child: Text(
                                                                  musicAdd.artist[
                                                                      countMy!],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              subtitle: Center(
                                                                child: Text(
                                                                  musicAdd.trackName[
                                                                      countMy!],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                  ),
                                                                ),
                                                              ),
                                                              trailing: StatefulBuilder(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                return IconButton(
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                  ),
                                                                  iconSize: 20,
                                                                  onPressed:
                                                                      () {
                                                                    state(() {
                                                                      //delete
                                                                    });
                                                                  },
                                                                );
                                                              })),
                                                        ),
                                                        StatefulBuilder(builder:
                                                            (context, state) {
                                                          return Slider(
                                                              min: 0,
                                                              max: duration
                                                                  .inSeconds
                                                                  .toDouble(),
                                                              value: position
                                                                  .inSeconds
                                                                  .toDouble(),
                                                              onChanged:
                                                                  (value) {
                                                                state(() {
                                                                  final position =
                                                                      Duration(
                                                                          seconds:
                                                                              value.toInt());
                                                                  print(formatTime(
                                                                      position));
                                                                  audioPlayer.seek(
                                                                      position);
                                                                  audioPlayer
                                                                      .resume();
                                                                });
                                                              });
                                                        }),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(formatTime(
                                                                  position)),
                                                              Text(formatTime(
                                                                  duration -
                                                                      position)),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 40,
                                                                      right:
                                                                          15),
                                                              child: StatefulBuilder(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                return CircleAvatar(
                                                                  radius: 35,
                                                                  child: IconButton(
                                                                      icon: Icon(
                                                                        Icons
                                                                            .skip_previous_rounded,
                                                                      ),
                                                                      iconSize: 40,
                                                                      onPressed: () async {
                                                                        if (countMy !=
                                                                            0) {
                                                                          countMy =
                                                                              countMy! - 1;
                                                                          await audioPlayer
                                                                              .play(UrlSource(musicAdd.musicUrl[countMy!]));
                                                                        } else {
                                                                          await audioPlayer
                                                                              .dispose();
                                                                          state(
                                                                              () {
                                                                            isMyPlaying =
                                                                                false;
                                                                          });
                                                                        }
                                                                      }),
                                                                );
                                                              }),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                top: 40,
                                                              ),
                                                              child: StatefulBuilder(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                return CircleAvatar(
                                                                  radius: 35,
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                      isMyPlaying
                                                                          ? Icons
                                                                              .pause
                                                                          : Icons
                                                                              .play_arrow,
                                                                    ),
                                                                    iconSize:
                                                                        40,
                                                                    onPressed:
                                                                        () async {
                                                                      if (isMyPlaying) {
                                                                        state(
                                                                            () {
                                                                          isMyPlaying =
                                                                              false;
                                                                        });
                                                                        await audioPlayer
                                                                            .pause();
                                                                      } else {
                                                                        state(
                                                                            () {
                                                                          isMyPlaying =
                                                                              true;
                                                                        });
                                                                        await audioPlayer
                                                                            .play(UrlSource(musicAdd.musicUrl[countMy!]));
                                                                      }
                                                                    },
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 40,
                                                                      left: 15),
                                                              child: StatefulBuilder(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                return CircleAvatar(
                                                                  radius: 35,
                                                                  child: IconButton(
                                                                      icon: Icon(
                                                                        Icons
                                                                            .skip_next_rounded,
                                                                      ),
                                                                      iconSize: 40,
                                                                      onPressed: () async {
                                                                        if (countMy !=
                                                                            musicAdd.musicUrl.length -
                                                                                1) {
                                                                          countMy =
                                                                              countMy! + 1;
                                                                          await audioPlayer
                                                                              .play(UrlSource(musicAdd.musicUrl[countMy!]));
                                                                        } else {
                                                                          await audioPlayer
                                                                              .dispose();
                                                                          state(
                                                                              () {
                                                                            isMyPlaying =
                                                                                false;
                                                                          });
                                                                        }
                                                                      }),
                                                                );
                                                              }),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          });
                                    }));
                          }));
                }
              },
            );
          }
        }));
  }
}

/**
 
 FractionallySizedBox(
                                                  heightFactor: 0.75,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: Image.network(
                                                            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                                                            width: 350,
                                                            height: 350,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 32,
                                                      ),
                                                      const Text(
                                                        'The Flutter song',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Sahar Abs',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                      StatefulBuilder(builder:
                                                          (context, state) {
                                                        return Slider(
                                                            min: 0,
                                                            max: duration
                                                                .inSeconds
                                                                .toDouble(),
                                                            value: position
                                                                .inSeconds
                                                                .toDouble(),
                                                            onChanged: (value) {
                                                              state(() {
                                                                final position =
                                                                    Duration(
                                                                        seconds:
                                                                            value.toInt());
                                                                print(formatTime(
                                                                    position));
                                                                audioPlayer.seek(
                                                                    position);
                                                                audioPlayer
                                                                    .resume();
                                                              });
                                                            });
                                                      }),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 16),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(formatTime(
                                                                position)),
                                                            Text(formatTime(
                                                                duration -
                                                                    position)),
                                                          ],
                                                        ),
                                                      ),
                                                      StatefulBuilder(builder:
                                                          (context, state) {
                                                        return CircleAvatar(
                                                          radius: 35,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                            ),
                                                            iconSize: 50,
                                                            onPressed:
                                                                () async {
                                                              if (isPlaying) {
                                                                state(() {
                                                                  isPlaying =
                                                                      false;
                                                                });
                                                                await audioPlayer
                                                                    .pause();
                                                              } else {
                                                                state(() {
                                                                  isPlaying =
                                                                      true;
                                                                });
                                                                await audioPlayer.play(UrlSource(
                                                                    infoMusic!["musics"]
                                                                            [
                                                                            "musicUrl"]
                                                                        [
                                                                        count]));
                                                              }
                                                            },
                                                          ),
                                                        );
                                                      })
                                                    ],
                                                  ),
                                                );
 */
/**
 return FractionallySizedBox(
                                                heightFactor: 0.75,
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg",
                                                          width: 350,
                                                          height: 350,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 32,
                                                    ),
                                                    const Text(
                                                      'The Flutter song',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'Sahar Abs',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (context, state) {
                                                      return Slider(
                                                          min: 0,
                                                          max: duration
                                                              .inSeconds
                                                              .toDouble(),
                                                          value: position
                                                              .inSeconds
                                                              .toDouble(),
                                                          onChanged: (value) {
                                                            state(() {});
                                                          });
                                                    }),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(formatTime(
                                                              position)),
                                                          Text(formatTime(
                                                              duration -
                                                                  position)),
                                                        ],
                                                      ),
                                                    ),
                                                    StatefulBuilder(builder:
                                                        (context, state) {
                                                      return CircleAvatar(
                                                        radius: 35,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            isPlaying
                                                                ? Icons.pause
                                                                : Icons
                                                                    .play_arrow,
                                                          ),
                                                          iconSize: 50,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                    })
                                                  ],
                                                ),
                                              );
 */