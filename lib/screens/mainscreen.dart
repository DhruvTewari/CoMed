import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hackfinity/components/rounded_button.dart';
import 'package:hackfinity/location.dart';
import 'package:hackfinity/network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'link.dart';

final apiKey = 'API_KEY';
final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=';
final Firestore _firestore = Firestore.instance;
FirebaseUser loggedInUser;
List hospitalNames = List();

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

String HospitalName = 'Will be Updated Automatically';

class MainScreen extends StatefulWidget {

  static String id = '/main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  void checkUser() async {
    getCurrentUser();
    await for(var snap in _firestore.collection('data').snapshots()) {
      for(var msg in snap.documents) {
        print(loggedInUser.email);
        if (msg.data['email'] == loggedInUser.email) {
          print(msg.data);
          Navigator.popAndPushNamed(context, Link.id);
        }
      }
    }
  }
  var now = DateTime.now();
  String curr_date;

  final _auth = FirebaseAuth.instance;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    curr_date = '${now.day}/${now.month}/${now.year}';
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

  DateTime _dateTime;

  void curr_da(String s){
    curr_date = s;
  }

  Future<String> update() async  {
    var json = await getHospitalsData(url);
    hospitalNames = getHospital(json);
    Random random = new Random();
    int randomNumber = random.nextInt(hospitalNames.length);
    setState(() {

    });

    return hospitalNames[randomNumber].toString();
  }


  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    // int current_day = DateTime.now().day;
    // int current_month = DateTime.now().month;
    // int current_year = DateTime.now().year;


    List hospitalNames = List();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
          backgroundColor: Color(0xFF1aa5c2).withOpacity(0.8),
          brightness: Brightness.light,
          title: Text('Details'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            // To Do
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
              Padding(
                padding: EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        width: width*1,
                        height: height*0.3,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          )
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                    'Choose Date Of Vaccination',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    letterSpacing: 0.3,
                                    // fontStyle: ,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(child: SizedBox(height: 20,)),
                            Text(
                              '$curr_date',
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            Text(
                                _dateTime == null ? 'Nothing has been picked yet' : _dateTime.toString()),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text('Pick a date'),
                                onPressed: () async {
                                  var hospital = await update();
                                  showDatePicker(
                                      context: context,
                                      initialDate: _dateTime == null ? DateTime(DateTime.now().year,DateTime.now().month,
                                          DateTime.now().day) : _dateTime,
                                      firstDate: DateTime(2019,10,3),
                                      lastDate: DateTime(2022)
                                  ).then((date) {
                                    setState(() {
                                      _dateTime = date;
                                      curr_da('${date.day}/${date.month}/${date.year}');
                                      HospitalName = hospital;
                                    });
                                  });
                                },
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Flexible(child: SizedBox(height: 0.03*height,)),
            Flexible(
              child: Padding(
                padding:  EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        width: width*1,
                        height: height*0.2,
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                            )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Flexible(
                              child: Padding(
                                padding:  EdgeInsets.only(top: 16.0),
                                child: Text(
                                  '$HospitalName',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400
                                  ),

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height:0.05*height,),

            Align(
              alignment: Alignment.bottomCenter,
              child: RoundedButton(
                color: Color(0xFF2a52be),
                textEnter: 'Submit',

                onPressed: () async{

                  _firestore.collection('data').add({
                    'Date' : '$curr_date',
                    'hospitalName' : '$HospitalName',
                    'email' : loggedInUser.email.toString(),
                    'infoStatus' : true,
                  });
                  setState(() {
                    Navigator.popAndPushNamed(context, Link.id);
                  });

                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}