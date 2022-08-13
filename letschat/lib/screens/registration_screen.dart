import 'package:flutter/material.dart';
import 'package:letschat/constants.dart';
import 'chat_screen.dart';
import 'button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'Registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // ignore: prefer_typing_uninitialized_variables
  bool showspinner = false;
  late final _auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  late String email;
  late String pasword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: kInputdecorations('Enter your name'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    pasword = value;
                    //Do something with the user input.
                  },
                  decoration: kInputdecorations('Enter your Password')),
              SizedBox(
                height: 24.0,
              ),
              button('Register', kbutton2, () async {
                setState(() {
                  showspinner = true;
                });
                // print(email);
                // print(pasword);
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: pasword);
                  if (newUser != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    showspinner = false;
                  });
                } catch (e) {
                  print(e);
                }
              }).butt(),
            ],
          ),
        ),
      ),
    );
  }
}
