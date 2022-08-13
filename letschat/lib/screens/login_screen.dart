import 'package:flutter/material.dart';
import 'package:letschat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'button.dart';
import 'package:letschat/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  late final _auth = FirebaseAuth.instance;
  late String email;
  late String pasword;
  void initState()  {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();
  }

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
                decoration: kInputdecorations('Enter your email'),
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
                decoration: kInputdecorations('Enter your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              button('Log IN', kbutton1, () async {
                setState(() {
                  showspinner = true;
                });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: pasword);
                  if (user != null) {
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
