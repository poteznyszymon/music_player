import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formatedTime = '${duration.inMinutes}:$twoDigitSeconds';

    return formatedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      final playlist = value.playlist;
      final song = playlist[value.currentSongIndex ?? 0];
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          title: const Text('Now playing'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SwipeDetector(
                onSwipeLeft: (offset) {
                  value.playNextSong();
                },
                onSwipeRight: (offset) {
                  value.playPreviusSong();
                },
                child: Image.asset(song.albumArtImagePath),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.songName,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          song.artisName,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 4),
                  trackHeight: 2),
              child: Slider(
                min: 0,
                max: value.totalDuration.inSeconds.toDouble(),
                value: value.currentDuration.inSeconds.toDouble(),
                onChanged: (double double) {
                  value.seek(Duration(seconds: double.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(value.currentDuration),
                  ),
                  Text(formatTime(value.totalDuration)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shuffle,
                  size: 25,
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    value.playPreviusSong();
                  },
                  child: const Icon(
                    Icons.skip_previous,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    value.pauseOrResume();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Icon(
                      value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    value.playNextSong();
                  },
                  child: const Icon(
                    Icons.skip_next,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 30),
                const Icon(
                  Icons.repeat,
                  size: 25,
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
