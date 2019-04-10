import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';


void main() async {
  runApp(
      new MaterialApp(
          home: new SplashScreen(),
          routes: <String, WidgetBuilder>{
              //Define routes here
          }
      )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // Timer(Duration(seconds: 5), () =>  Navigator.pushReplacementNamed(context, '/loginPage'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.black87,
              image: new DecorationImage(image:
                new AssetImage(
                  "assets/splashscreen.jpg"
                ),
                fit: BoxFit.fill
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 4,
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
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[                    Text(
                    "",
                    style: TextStyle(
                        fontFamily: 'Courier New',
                        fontStyle: FontStyle.normal,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0),
                  ),
                    SizedBox(height: 100,),
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