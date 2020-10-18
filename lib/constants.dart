import 'package:flutter/material.dart';

int left(String dates){
  var l = dates.split('/');
  int year = double.parse(l[2]).toInt();
  int day = double.parse(l[0]).toInt();
  int month = double.parse(l[1]).toInt();

  var diff = DateTime(year,month,day).difference(DateTime.now()).inDays + 1;
  // print(diff);
  return diff;

}


final apiKey = 'AIzaSyCucUot-tluWcLZ3GoGgir7bzLvD4cPDSM';

String logged_dates;
String logged_email;
String logged_hospital;

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);


const kcontent = InputDecoration(
  hintText: 'Hint Text',
  suffixStyle: TextStyle(
    fontSize: 20,
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
