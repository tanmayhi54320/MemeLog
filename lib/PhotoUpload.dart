import 'package:blogapp/LoginPage.dart';
import 'package:blogapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

FirebaseUser loggedInUser;
class PhotoUploads extends StatefulWidget {
  static const id='PhotoUpload';
  @override
  _PhotoUploadsState createState() => _PhotoUploadsState();
}

class _PhotoUploadsState extends State<PhotoUploads> {
  File sampleImage;
  final formKey=GlobalKey<FormState>();
  String userId;
  String _myValue;
  String url;
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
        userId=loggedInUser.email;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  Future getImage()async{
    var tempImg=await ImagePicker().getImage(source:ImageSource.gallery);
    setState(() {
      sampleImage=File(tempImg.path);
    });
  }

  // ignore: non_constant_identifier_names
  bool ValidateAndSave(){
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      return true;
    }
    else{
      return false;
    }
  }
  // ignore: non_constant_identifier_names
  void UpdateAndSave()async{
    if(ValidateAndSave()){
        final StorageReference postImageRef=FirebaseStorage.instance.ref().child('Photos Upload');
        var timekey=DateTime.now();

        final StorageUploadTask uploadTask=postImageRef.child(timekey.toString()+'.jpg').putFile(sampleImage);
        var imageUrl=await(await uploadTask.onComplete).ref.getDownloadURL();
        url=imageUrl.toString();
        Navigator.pop(context);
        SaveToDatabase(url);

    }
  }
  // ignore: non_constant_identifier_names
  void SaveToDatabase(String url){
      var dbTimeKey=DateTime.now();
      var dateFormat=DateFormat('MMM d,yyyy');
      var timeFormat=DateFormat('EEEE,hh:mm aaa');

      var date=dateFormat.format(dbTimeKey);
      var time=timeFormat.format(dbTimeKey);

      DatabaseReference ref=FirebaseDatabase.instance.reference();

      var data={
        'image':url,
        'description':_myValue,
        'date':date,
        'time':time,
        'user':userId,
      };
      
      ref.child('posts').push().set(data);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MemeLog',
          style: kTitleText,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: sampleImage==null?Text('Enter an image'):enableUpload(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(
          Icons.add_a_photo,
        ),

      ),
    );
  }
  // ignore: missing_return
  Widget enableUpload() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.file(sampleImage, height: 330.0, width: 660.0,),

            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Caption',
              ),
              validator: (value) {
                return value == null ? 'Caption is required' : null;
              },
              onSaved: (value) {
                _myValue = value;
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text(
                'Add Post',
                style: kButtonStyle,
              ),
              //shape: ,
              onPressed: UpdateAndSave,
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
