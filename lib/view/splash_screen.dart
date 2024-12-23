import 'package:audio_player_demo/exports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      // Get.offAll(() => HomeScreen());
      Get.offAll(() => AudioPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'SplashScreen',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
