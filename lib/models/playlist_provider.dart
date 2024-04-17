import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      id: '1',
      songName: 'Loading',
      artisName: 'Centrall Cee',
      albumArtImagePath: 'assets/images/album_1.jpg',
      audioPath: 'audio/loading.mp3',
    ),
    Song(
      id: '2',
      songName: 'Save Your Tears',
      artisName: 'The weekend',
      albumArtImagePath: 'assets/images/album_2.jpg',
      audioPath: 'audio/saveyourtears.mp3',
    ),
    Song(
      id: '3',
      songName: "God's plan",
      artisName: 'Drake',
      albumArtImagePath: 'assets/images/album_3.jpg',
      audioPath: "audio/god'splan.mp3",
    ),
    Song(
      id: '4',
      songName: "P.S.W.I.S. (DJ Eprom remix)",
      artisName: 'Belmondawg',
      albumArtImagePath: 'assets/images/album_4.jpg',
      audioPath: 'audio/pswis.mp3',
    ),
    Song(
      id: '5',
      songName: "Bolesław Krzywousty",
      artisName: 'Kaz Balagane',
      albumArtImagePath: 'assets/images/album_5.jpg',
      audioPath: 'audio/krzywousty.mp3',
    )
  ];

  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    listenToDuration();
  }

  bool _isPlaying = false;

  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviusSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  /// GETTERS
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    notifyListeners();
  }
}
