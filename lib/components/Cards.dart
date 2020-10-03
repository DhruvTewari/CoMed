import 'package:flutter/material.dart';

Widget cards(String image, String place){
  return AspectRatio(
    aspectRatio: 3 / 3,
    child: Container(
      margin: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.fill,
        ),

      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                stops: [0.1,0.9],
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.2),
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$place',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white.withOpacity(1),
                backgroundColor: Colors.black87.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}