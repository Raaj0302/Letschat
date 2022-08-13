import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:letschat/screens/login_screen.dart';

class button {
  button(
    this.text,
    this.color,
    this.re,
  );
  String text;
  Color color;
  Function re;

  // Navigator navigator;

  Widget butt() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            re();
            // Navigator.pushNamed(, LoginScreen.id);
            //   //Go to login screen.
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
