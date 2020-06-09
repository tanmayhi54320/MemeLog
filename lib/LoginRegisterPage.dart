import 'package:blogapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;
class HomePage extends StatefulWidget {
  static const id='LoginRegistrationPage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(
          child: Text(
            'MemeLog',
            style: kTitleText,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.input,
              color: Colors.white,
            ),
            onPressed: _logOutUser,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: (){
                    Navigator.pushNamed(context, HomePage.id);
                  },
                  child: Icon(
                    Icons.add_a_photo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _logOutUser() async {
    _auth.signOut();
    Navigator.pop(context);
  }
}
