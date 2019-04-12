import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';

import 'LoginPage.dart';
import 'HomeScreen.dart';


void main() async {
  runApp(
      new MaterialApp(
          home: new SplashScreen(),
          routes: <String, WidgetBuilder>{
            "/loginPage": (BuildContext context) => new Login(),
            "/userHome": (BuildContext context) => new userHomeScreen(),
          }
      )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


final logo_img = new CircleAvatar(
  radius: 50.0,
  backgroundColor: Colors.black,
  child:  Container(
    decoration: BoxDecoration(color: Colors.black87,
      image: new DecorationImage(image:
      new AssetImage(
          "assets/logo.png"
      ),
          fit: BoxFit.fill
      ),
    ),
  ),
);



class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Timer(Duration(seconds: 5), () =>  Navigator.pushReplacementNamed(context, '/userHome'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black,
              image: new DecorationImage(image:
                new AssetImage(
                  "assets/logo.png"
                ),
                fit: BoxFit.fitWidth
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //ICON
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                    Text(
                    "",
                    style: TextStyle(
                        fontFamily: 'Courier New',
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0),
                  ),
                    RefreshProgressIndicator(backgroundColor: Colors.white,),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}