import 'package:audio_player_demo/exports.dart';

/// Using [GetX] State management
class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final audioController = Get.put(AudioController());

  @override
  void initState() {
    // set audio
    audioController.setAudio();

    /// Listen to state: playing, pause, stopped
    audioController.audioPlayer.onPlayerStateChanged.listen((state) {
      audioController.isPlaying.value = state == PlayerState.playing;
    });

    /// Listen to audio position
    audioController.audioPlayer.onPositionChanged.listen((newPosition) {
      audioController.position.value = newPosition;
    });

    /// Listen to audio duration
    audioController.audioPlayer.onDurationChanged.listen((newDuration) {
      audioController.duration.value = newDuration;
    });

    /// reset state when audio complete
    audioController.audioPlayer.onPlayerComplete.listen((state) {
      audioController.position.value = Duration.zero;
      audioController.audioPlayer.pause();
      audioController.audioPlayer.seek(audioController.position.value);
    });

    super.initState();
  }

  @override
  void dispose() {
    audioController.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        toolbarHeight: kToolbarHeight - 10,
        centerTitle: true,
        title: Text(
          'Audio Demo',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15),
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
              Obx(
                () => Slider(
                  min: 0,
                  max: audioController.duration.value.inSeconds.toDouble(),
                  value: audioController.position.value.inSeconds.toDouble(),
                  activeColor: Colors.blueAccent,
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await audioController.audioPlayer.seek(position);

                    // Optional: Play audio if was paused
                    await audioController.audioPlayer.resume();
                  },
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text(audioController.formatDuration(audioController.position.value)),
                    ),
                    Obx(
                      () => Text(audioController.formatDuration(audioController.duration.value - audioController.position.value)),
                    ),
                  ],
                ),
              ),
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(audioController.formatDuration(audioController.position.value)),
                      Text(audioController.formatDuration(audioController.duration.value - audioController.position.value)),
                    ],
                  ),
                ),
              ),*/
              // SizedBox(height: 10),
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 35,
                child: Obx(
                  () => IconButton(
                    onPressed: () async {
                      audioController.handelPlayPause();
                    },
                    icon: Icon(
                      audioController.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
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
}
