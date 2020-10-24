import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hackfinity/components/rounded_button.dart';
import 'package:hackfinity/location.dart';
import 'package:hackfinity/network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackfinity/screens/mainscreen.dart';
import 'package:hackfinity/screens/userInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../constants.dart';

final apiKey = 'API_KEY';
final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=';
final Firestore _firestore = Firestore.instance;
FirebaseUser loggedInUser;

Future<dynamic> getHospitalsData(String url) async {
  Location location = Location();
  await location.getCurrentLocation();
  NetworkHelper networkHelper = NetworkHelper(
      '$url${location.latitude},${location.longitude}&type=hospital&rankby=distance&key=$apiKey'
  );

  var weatherData = await networkHelper.getData();
  return weatherData;
}

List getHospital(var json) {
  List names = List();
  for (var data in json['results']) {
    if (data["business_status"] == "OPERATIONAL") {
      String s = data['name'].toString();
      if (s != null) {
        names.add(s);
      }
    }
  }
  // print(names);
  return names;
}


class Link extends StatefulWidget {

  static String id = '/link';
  @override
  _LinkState createState() => _LinkState();
}
String email = '',Date='',hospitalName='';
bool infoStatus = false;

class _LinkState extends State<Link> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;

  final _auth = FirebaseAuth.instance;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {

      });

    });
  }



  void getCurrentUser() async {

    var json = await getHospitalsData(url);
    List hospitalNames = getHospital(json);
    try{
      final user = await _auth.currentUser();
      if(user!=null){
        loggedInUser = user;
      }
    } catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    void checkUser() async {
      await for(var snap in _firestore.collection('data').snapshots()) {
        for(var msg in snap.documents) {
          if (msg.data['email'] == loggedInUser.email) {
            logged_email = loggedInUser.email;
            logged_dates = msg.data['Date'];
            logged_hospital = msg.data['hospitalName'];
            infoStatus = msg.data['infoStatus'];
            if(msg.data['infoStatus'] == true) {
              // print(msg.data['Date']);

              Navigator.popAndPushNamed(context, userInfo.id);
            }
          }
        }
      }
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Text('Almost Done',
          style: TextStyle(
            fontSize: 40*animation.value,
            fontWeight: FontWeight.bold,

          ),
          ),
          Align(
            alignment: Alignment.center,
            child: RoundedButton(onPressed: () {

              checkUser();
              setState(() {

              });
              if(infoStatus == false){
                Navigator.popAndPushNamed(context, MainScreen.id);
              }
            },
              color: Colors.blue,
              textEnter: 'Click To Proceed',
            ),

          ),
          // Text(
          //   '$Date',
          // )
        ],
      ),
    );
  }
}
