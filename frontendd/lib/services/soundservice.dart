import 'package:audioplayers/audioplayers.dart';

class WorkoutSoundService {
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer musicplayer = AudioPlayer();
  Future<void> playBackgroundMusic() async {
    await musicplayer.setReleaseMode(ReleaseMode.loop);
    await musicplayer.play(AssetSource('audio/exercisemusic.mp3'), volume: 0.4);
  }

  Future<void> stopBackgroundMusic() async {
    await musicplayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await musicplayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await musicplayer.resume();
  }

  void dispose() {
    player.dispose();
    musicplayer.dispose();
  }
}
