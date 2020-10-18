import 'package:flutter/material.dart';
import 'login.dart';
import 'registeration.dart';
import 'package:hackfinity/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {

  static String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );
    _controller.forward();
    // _controller.addListener(() {
    // setState(() {
    //
    // });
    // print(animation.value);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2884C6),
        elevation: 0,
        toolbarHeight: 0.04*height,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 0.1*height,
              color: Color(0xFF2884C6),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(80.0)),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(height*0.018),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Flexible(

                            child: Text(
                              'CoMed',
                              style: TextStyle(
                                fontSize: 0.060*height,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEA4C89).withAlpha(200),

                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:height*0.016),
                      child: FadeAnimatedTextKit(
                        duration: Duration(seconds: 16),


                        onTap: (){
                        },
                        text: [
                          'Hello',
                          'नमस्ते',
                          'Hola',
                          'مرحبا',
                          'Bonjour',
                          'Hello',
                        ],
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                          fontSize: 38,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          // fontStyle: ,
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 0.48*height,
                      ),
                    ),

                    Flexible(
                      flex: 3,
                      child: Image(
                        image: AssetImage('images/cover.jpg'),

                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 0.08*height,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: RoundedButton(
                        color: Color(0xFF2884C6),
                        onPressed:() {
                          Navigator.pushNamed(context, Login.id);
                          //Go to login screen.
                        },
                        textEnter: 'Log In',
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: RoundedButton(
                        color: Color(0xFFF6ADD0),
                        onPressed:() {
                          Navigator.pushNamed(context, Registeration.id);
                          //Go to login screen.
                        },
                        textEnter: 'Register',
                      ),
                    ),



                  ],
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
