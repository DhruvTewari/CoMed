import 'package:flutter/material.dart';
import 'package:hackfinity/screens/link.dart';
import 'package:hackfinity/screens/userInfo.dart';
import 'screens/welcome_screen.dart';
import 'screens/registeration.dart';
import 'screens/login.dart';
import 'screens/link.dart';

import 'package:flutter/services.dart';
import 'screens/mainscreen.dart';

void main() {
  runApp(CoMed());
}

class CoMed extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        Login.id : (context) => Login(),
        Registeration.id : (context) => Registeration(),
        MainScreen.id : (context) => MainScreen(),
        userInfo.id : (context) => userInfo(),
        Link.id : (context) => Link(),
      },

    );
  }
}