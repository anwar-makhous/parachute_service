import 'package:flutter/material.dart';
import '/screens/video_page.dart';
import '/screens/intro_page.dart';
import '/global_state.dart';
import 'package:flutter/services.dart';

String? checkLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkLocation = await GlobalState.getLocation();
  // checkLocation = 'HAHAHAHAHA';
  // GlobalState.checkLogIn();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Parachute',
      debugShowCheckedModeBanner: false,
      color: GlobalState.logoColor,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: GlobalState.logoColor)),
      home:
          (checkLocation == 'nowhere') ? const VideoPage() : const IntroPage(),
    );
  }
}
