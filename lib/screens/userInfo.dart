import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hackfinity/location.dart';
import 'package:hackfinity/network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackfinity/components/Cards.dart';


import '../constants.dart';

final apiKey = 'AIzaSyCucUot-tluWcLZ3GoGgir7bzLvD4cPDSM';
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

String date;
String email;
String hospital;

String logEmail = loggedInUser.email;
void checkUser() async {
  await for(var snap in _firestore.collection('data').snapshots()) {
    for(var msg in snap.documents) {
      if(msg.data['email'] == logEmail){
        email = loggedInUser.email;
        date = msg.data['Date'];
        hospital = msg.data['hospitalName'];
        print(msg.data);
      }
    }
  }
}


class userInfo extends StatefulWidget {

  static String id = '/userInfo';
  @override
  _userInfoState createState() => _userInfoState();
}



String daysLeft(String dates){
  var l = dates.split('/');
  int year = double.parse(l[2]).toInt();
  int day = double.parse(l[0]).toInt();
  int month = double.parse(l[1]).toInt();

  var diff = DateTime(year,month,day).difference(DateTime.now()).inDays + 1;
  // print(diff);
  days = diff.toString();
  return diff.toString();
}
String days;

class _userInfoState extends State<userInfo> {
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {

    var json = await getHospitalsData(url);
    List hospitalNames = getHospital(json);
    try{
      final user = await _auth.currentUser();
      if(user!=null){
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch(e){
      print(e);
    }
  }

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    daysLeft(logged_dates);
    print(days);
    // checkUser();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Color(0xFFFFFEFF),
        title: Text(
          'Information',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),

        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), onPressed: () {
            Navigator.pop(context);
        },
        ),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          reverse: false,
          children: [
            Column(
              children: [

                Padding(
                  padding:  EdgeInsets.all(14.0),
                  child: Container(
                    height: height *0.3,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: Color(0xFF2D2D36),
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),

                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 28, left: 16.0,right: 40,bottom: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: FadeAnimatedTextKit(
                              duration: Duration(seconds: 16),


                              onTap: (){
                                setState(() {
                                  daysLeft(logged_dates);
                                });
                              },
                              text: [
                                'User',
                                'उपयोगकर्ता',
                                'usuaria',
                                'المستعمل',
                                'utilisatrice',
                                'User',
                              ],
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,

                                // fontStyle: ,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Email id of user : $logged_email',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 18.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Hospital Name : $logged_hospital',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Container(
                    height: height * 0.18,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: Color(0xFF2D2D36),
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),

                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'Days for Vaccination',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom:0.04*height),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              days,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 0.02*height,),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          'Follow the Steps',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 20,),

                        Icon(
                          Icons.arrow_forward_outlined,
                          size: 40,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0.02*height,),

                Container(
                  color: Colors.grey.withOpacity(0.1),
                  height: 250,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: cards(
                          'images/sanitizer.jpg',
                          'Sanitize'
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: cards(
                            'images/distance.jpg',
                            'Social Distancing'
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: cards(
                            'images/mask.jpg',
                            'Wear Mask'
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
