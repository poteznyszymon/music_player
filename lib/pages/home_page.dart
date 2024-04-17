import 'package:flutter/material.dart';
import 'package:music_app/models/playlist_provider.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/pages/song_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playListProvider;
  @override
  void initState() {
    playListProvider = Provider.of<PlaylistProvider>(context, listen: false);
    super.initState();
  }

  void goToSong(int songIndex) {
    playListProvider.currentSongIndex = songIndex;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SongPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        elevation: 0,
        title: const Text('My playlist'),
      ),
      body: Consumer<PlaylistProvider>(builder: (context, value, child) {
        final List<Song> playlist = value.playlist;
        final Song activeSong = playlist[value.currentSongIndex ?? 0];
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.25,
              child: ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {
                  if (!value.isPlaying) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Song item = playlist.removeAt(oldIndex);
                      playlist.insert(newIndex, item);
                    });
                  }
                },
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  final Song song = playlist[index];
                  return Padding(
                    key: ValueKey(song.id),
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: ListTile(
                      onTap: () => goToSong(index),
                      title: Text(
                        song.songName,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(song.artisName),
                      leading: Image.asset(song.albumArtImagePath),
                      trailing: const Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: value.isPlaying
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SongPage()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.55,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                        activeSong.albumArtImagePath,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activeSong.songName,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(activeSong.artisName),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () {
                                  value.pauseOrResume();
                                },
                                child: Icon(Icons.pause),
                              ),
                              const SizedBox(width: 25),
                              GestureDetector(
                                onTap: () {
                                  value.playNextSong();
                                },
                                child: Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            )
          ],
        );
      }),
    );
  }
}
