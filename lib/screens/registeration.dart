import 'package:flutter/material.dart';
import 'package:hackfinity/screens/link.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hackfinity/constants.dart';
import 'package:hackfinity/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Registeration extends StatefulWidget {

  static String id = '/reg';
  @override
  _RegisterationState createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
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
                  email = value;

                  //Do something with the user input.
                },

                decoration: kcontent.copyWith(hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.email_outlined)) ,
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
                decoration: kcontent.copyWith(hintText: 'Enter Password (min: 6 characters)',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                onPressed:() async {
                  setState(() {
                    changeState = true;
                  });
                  try{
                    // print(email);
                    // print(pass);
                    final newuser = await _auth.createUserWithEmailAndPassword(email: email, password: pass);


                    if(newuser != null){
                      Navigator.pushNamed(context, Link.id);
                    }
                    setState(() {
                      changeState = false;
                    });

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
                textEnter: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
