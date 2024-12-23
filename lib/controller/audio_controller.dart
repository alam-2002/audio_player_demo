import 'package:audio_player_demo/exports.dart';

class AudioController extends GetxController {
  final audioPlayer = AudioPlayer();
  Rx<Duration> duration = Duration.zero.obs;
  Rx<Duration> position = Duration.zero.obs;
  RxBool isPlaying = false.obs;

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future setAudio() async {
    // Repeat song when complete
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    /// Load audio from URL
    const String songUrl =
        'https://firebasestorage.googleapis.com/v0/b/spotify0101.appspot.com/o/songs%2FBillie%20Eilish%20%2C%20Khalid%20-%20lovely.mp3?alt=media';
    await audioPlayer.setSourceUrl(songUrl);
    print('Loaded audio URL: $songUrl');

    /// Load audio from file
    // final result = await FilePicker.platform.pickFiles();
    // if (result != null) {
    //   final file = File(result.files.single.path!);
    //   audioPlayer.setSourceDeviceFile(file.path);
    //   print('Loaded audio file path: $file');
    // }

    /// Load audio from assets
    // await audioPlayer.setSourceAsset('Afterglow.mp3');
  }

  handelPlayPause() async {
    if (isPlaying.value == true) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }
}
