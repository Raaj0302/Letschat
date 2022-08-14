// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedin = loggedin;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String msg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedin = user;
        print(loggedin.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  // final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  void msgsStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var msgs in snapshot.docs) {
        print(msgs.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                // getMessages();
                msgsStream();
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Color.fromARGB(255, 29, 11, 81),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      controller: messageTextController,
                      onChanged: (value) {
                        msg = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'email': loggedin.email,
                        'text': msg,
                        'time': DateTime.now().year.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString()+"-"+DateTime.now().hour.toString()+"-"+DateTime.now().minute.toString()+"-"+DateTime.now().second.toString(),
                      });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print('inside');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        // print('outside');
        final message = snapshot.data;
        List<ChatBubble> msgwidgets = [];

        final mes = snapshot.data!.docs.reversed;
        for (var msgss in mes) {
          final messageSender = msgss['email'];
          final messageText = msgss['text'];
          // print(messageText);
          // print(messageSender);
          final currentUser = loggedin.email;
          bool check = false;
          if (currentUser == messageSender) {
            check = true;
          }
          final messageWidget = ChatBubble(
              messageSender, messageText, check);
          print(currentUser == loggedin.email);
          msgwidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: msgwidgets,
          ),
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  ChatBubble(this.sender, this.text, this.isMe);
  final String sender;
  final String text;
  final bool isMe;
  // ignore: prefer_const_constructors
  // Color clr=(isMe==true)?Color.fromARGB(167, 245, 193, 22):Color.alphaBlend(Colors.yellow, kbackground);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: (isMe)?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.white54),
          ),
          Material(
              borderRadius: BorderRadius.only(
                  topRight: (!isMe) ? Radius.circular(30.0) : Radius.circular(0),
                  topLeft: (!isMe) ? Radius.circular(0) : Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
              color: (isMe)
                  ? Color.fromARGB(167, 6, 65, 244)
                  : Color.fromARGB(255, 114, 81, 243),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Text(
                  '$text ',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              )),
        ],
      ),
    );
    // msgwidgets.add(messageWidget);
  }
}
