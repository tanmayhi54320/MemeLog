import 'package:blogapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static const id = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String email = "";
  String password = "";
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  // ignore: non_constant_identifier_names
  bool ValidateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> ValidateAndSubmit() async {
    if (ValidateAndSave() && password != "") {
      try {
        if (_formType == FormType.login) {
          final user = await _auth.signInWithEmailAndPassword(
              email: email.trim(), password: password);
          if (user != null) {
            Navigator.pushNamed(context, LoginPage.id);
          }
        } else {
          final newUser = await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: password);
          if (newUser != null) {
            Navigator.pushNamed(context, LoginPage.id);
          }
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'The E-mail or Password is invalid',
          toastLength: Toast.LENGTH_LONG,
        );
        print(e);
      }
    }
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(
          child: Text(
            'MemeLog',
            style: kTitleText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    if (_formType == FormType.login) {
      return [
        SizedBox(
          height: 10.0,
        ),
        logoImage(),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          onChanged: (value) {
            return email = value;
          },
          validator: (value) {
            return value.isEmpty ? 'Email can not be empty' : null;
          },
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          onChanged: (value) {
            password = value;
          },
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
      ];
    } else {
      return [
        SizedBox(
          height: 10.0,
        ),
        logoImage(),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          validator: (value) {
            return value.isEmpty ? 'Email can not be empty' : null;
          },
          onChanged: (value) {
            return email = value;
          },
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          onChanged: (value) {
            password = value;
          },
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        SizedBox(
          height: 20.0,
        ),
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(labelText: 'Confirm Password'),
        ),
      ];
    }
  }

  Widget logoImage() {
    return Hero(
      tag: 'pic',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image(
          image: AssetImage(
            'images/logo.PNG',
          ),
        ),
      ),
    );
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Text(
            'Login',
            style: kButtonStyle,
          ),
          textColor: Colors.white,
          color: Colors.blueAccent,
          disabledColor: Colors.blueAccent,
          onPressed: ValidateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Don\'t have an account? Create an account',
            style: TextStyle(fontSize: 15.0),
          ),
          //color: Colors.blueAccent,
          textColor: Colors.blueAccent,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Text(
            'Create Account',
            style: kButtonStyle,
          ),
          textColor: Colors.white,
          color: Colors.blueAccent,
          disabledColor: Colors.blueAccent,
          onPressed: ValidateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Already have an account? Login',
            style: TextStyle(fontSize: 15.0),
          ),
          textColor: Colors.blueAccent,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
