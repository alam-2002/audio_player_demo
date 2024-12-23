import 'package:audio_player_demo/exports.dart';

/// Using [Default] State management
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    // set audio
    setAudio();

    /// Listen to state: playing, pause, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    /// Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    /// Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    /// reset state when audio complete
    // audioPlayer.onPlayerComplete.listen((state) {
    //   setState(() {
    //     position = Duration.zero;
    //   });
    //   audioPlayer.pause();
    //   audioPlayer.seek(position);
    // });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        toolbarHeight: kToolbarHeight - 10,
        centerTitle: true,
        title: Text(
          'Audio Demo',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://i1.sndcdn.com/artworks-000344377479-prcevs-t500x500.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Lovely',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Billie Eilish & Khalid (DeepRemix)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  // Optional: Play audio if was paused
                  await audioPlayer.resume();
                },
              ),
              // SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(formatTime(position), style: TextStyle(color: Colors.red)),
                    // Text(formatTime(duration - position), style: TextStyle(color: Colors.red)),
                    // SizedBox(width: 20),
                    Text(formatDuration(position)),
                    Text(formatDuration(duration - position)),
                  ],
                ),
              ),
              // SizedBox(height: 10),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                      // const String songUrl =
                      //     'https://firebasestorage.googleapis.com/v0/b/spotify0101.appspot.com/o/songs%2FBillie%20Eilish%20%2C%20Khalid%20-%20lovely.mp3?alt=media';
                      // await audioPlayer.play(UrlSource(songUrl));
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 50,
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // String formatTime(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = twoDigits(duration.inHours);
  //   final minutes = twoDigits(duration.inMinutes.remainder(60));
  //   final seconds = twoDigits(duration.inMinutes.remainder(60));
  //
  //   return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  // }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future setAudio() async {
    // Repeat song when complete
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    /// Load audio from URL
    // const String songUrl =
    //     'https://firebasestorage.googleapis.com/v0/b/spotify0101.appspot.com/o/songs%2FBillie%20Eilish%20%2C%20Khalid%20-%20lovely.mp3?alt=media';
    // await audioPlayer.setSourceUrl(songUrl);
    // print('Loaded file path: $songUrl');

    /// Load audio from file
    // final result = await FilePicker.platform.pickFiles();
    // if (result != null) {
    //   final file = File(result.files.single.path!);
    //   audioPlayer.setSourceDeviceFile(file.path);
    //   print('Loaded file path: ${url.path}');
    // }

    /// Load audio from assets
    await audioPlayer.setSourceAsset('Afterglow.mp3');
  }
}
