import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letschat/screens/welcome_screen.dart';
import 'package:letschat/screens/login_screen.dart';
import 'package:letschat/screens/registration_screen.dart';
import 'package:letschat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
void main()async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(FlashChat());
  await Firebase.initializeApp();

}


class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
