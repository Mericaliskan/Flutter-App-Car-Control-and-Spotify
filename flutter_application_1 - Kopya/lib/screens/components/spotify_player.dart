import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tesla_animated_app/constanins.dart';

class SpotifyPlayer extends StatefulWidget {
  const SpotifyPlayer({
    Key? key,
  }) : super(key: key);

  @override
  _SpotifyPlayerState createState() => _SpotifyPlayerState();
}

class _SpotifyPlayerState extends State<SpotifyPlayer> {
  bool isPlaying = false;
  double value = 0;
  final player = AudioPlayer();
  Duration? duration;
  int currentSongIndex = 0;

  List<String> songs = [
    "artric-monkeys.mp3",
    "adamlar.mp3",
    "madrigal.mp3",
  ];
  List<String> name = [
    'Do I Wanna Know?',
    'Sarılırım Birine',
    'Geçme Artık Sokağımdan',
  ];
  List<String> artists = [
    'Arctic Monkeys',
    'Adamlar',
    'Madrigal',
  ];
  List<String> images = [
    'assets/album1.png',
    'assets/album2.png',
    'assets/album3.png',
  ];
  void initPlayer() async {
    await player.setSource(AssetSource(songs[currentSongIndex]));
    duration = await player.getDuration();
  }

  void playSong(int index) async {
    currentSongIndex = index;
    await player.stop();
    await player.setSource(AssetSource(songs[currentSongIndex]));
    await player.resume();
    duration = await player.getDuration();
    player.onPositionChanged.listen((Duration d) {
      setState(() {
        value = d.inSeconds.toDouble();
      });
    });
  }

  void playPreviousSong() {
    int newIndex = currentSongIndex - 1;
    if (newIndex < 0) {
      newIndex = songs.length - 1;
    }
    playSong(newIndex);
  }

  void playNextSong() {
    int newIndex = currentSongIndex + 1;
    if (newIndex >= songs.length) {
      newIndex = 0;
    }
    playSong(newIndex);
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Setting the music cover
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(images[currentSongIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                name[currentSongIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                artists[currentSongIndex],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(value / 60).floor()}: ${(value % 60).floor()}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    width: 260.0,
                    child: Slider.adaptive(
                      onChangeEnd: (new_value) async {
                        setState(() {
                          value = new_value;
                          print(new_value);
                        });
                        await player.seek(Duration(seconds: new_value.toInt()));
                      },
                      min: 0.0,
                      value: value,
                      max: duration != null
                          ? duration!.inSeconds.toDouble()
                          : 0.0,
                      onChanged: (value) {},
                      activeColor: Colors.white,
                    ),
                  ),
                  Text(
                    duration != null
                        ? "${duration!.inMinutes} : ${duration!.inSeconds % 60}"
                        : "",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              // Setting the player controller
              SizedBox(height: 60.0),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: playPreviousSong,
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: primaryColor),
                      ),
                      width: 60.0,
                      height: 60.0,
                      child: InkWell(
                        onTap: () async {
                          if (isPlaying) {
                            await player.pause();
                          } else {
                            await player.resume();
                            player.onPositionChanged.listen((Duration d) {
                              setState(() {
                                value = d.inSeconds.toDouble();
                              });
                            });
                          }
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        child: Center(
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: playNextSong,
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
