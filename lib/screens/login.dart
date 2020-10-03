import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackfinity/screens/link.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hackfinity/components/rounded_button.dart';
import 'package:hackfinity/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


final Firestore _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Login extends StatefulWidget {

  static String id = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _auth = FirebaseAuth.instance;
  String email;
  String pass;
  bool changeState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: changeState,
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
                    child: Image.asset('images/cover.jpg'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kcontent.copyWith(hintText: 'Enter Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(

                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  pass = value;

                },
                decoration: kcontent.copyWith(hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock)
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                onPressed:() async {
                  // print(email);
                  // print(pass);
                  setState(() {
                    changeState = true;
                  });
                  try{
                    final newuser = await _auth.signInWithEmailAndPassword(email: email, password: pass);
                    if(newuser != null){
                      Navigator.pushNamed(context, Link.id);
                    }
                  } catch(e) {
                    print(e);
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Invalid Email or Password",

                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),

                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  }
                  setState(() {
                    changeState = false;
                  });
                },
                textEnter: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
