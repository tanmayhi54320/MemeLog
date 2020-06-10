import 'package:blogapp/LoginPage.dart';
import 'package:blogapp/constants.dart';
import 'package:blogapp/posts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;
class HomePage extends StatefulWidget {
  static const id='LoginRegistrationPage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList=[];
  final _auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference PostsRef=FirebaseDatabase.instance.reference().child('posts');

    PostsRef.once().then((DataSnapshot snap)
    {
      var keys=snap.value.keys;
      var data=snap.value;
      postList.clear();

      for(var individualKeys in keys){

        Posts post=Posts(
          image: data[individualKeys]['image'],
          date: data[individualKeys]['date'],
          description: data[individualKeys]['description'],
          user: data[individualKeys]['user'],
          time: data[individualKeys]['time'],
        );

        postList.add(post);
      }
      setState(() {
        print('Length : ${postList.length}');
      });
    });
    //getCurrentUser();

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
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushNamed(context, LoginPage.id);
            },
          ),
        ],
      ),
      body: Container(
        child: Container(
          child: postList.length==0?Text('No posts Yet'):ListView.builder(
              itemCount: postList.length,
              itemBuilder: (_,index){
                return postsUI(postList[index].user, postList[index].date, postList[index].image, postList[index].time, postList[index].description);
              },
          ),
        ),
      ),
    );
  }
  Widget postsUI(String user,String date, String image,String time,String description){
    return Card(
      elevation: 15.0,
      margin: EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                      Text(
                        date,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.center,
                      ),
                ],
              ),
            SizedBox(height: 10),
            Image.network(image,fit: BoxFit.cover,),

            SizedBox(height: 10.0,),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.center,
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
