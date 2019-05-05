import 'dart:async';
import 'package:fitness_app_flutter/Workouts.dart';
import 'package:flutter/services.dart';

import 'Home.dart';
import 'package:fitness_app_flutter/ServerResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Profile.dart';

class TabScreen extends StatefulWidget {
  final Post serverResponse;                // Includes the status,uid,accessToken
  TabScreen({Key key, @required this.serverResponse}) : super(key: key);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  List<Widget> _children=[];


// Currently initialized with Profile only, but first one should be home class
  @override

 Widget build(BuildContext context) {


    _children=[Home(serverResponse: widget.serverResponse,),
              Profile(serverResponse: widget.serverResponse,),
              Workout(serverResponse: widget.serverResponse),
    ];
    return new Scaffold(
        key: _scaffoldKey,
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped ,
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),

            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              title: Text('Workout'),
            )
          ],
        ),
    );
  }

  // Functions
  void onTabTapped(int index) {
    setState(() {
        _currentIndex = index;
    });
  }
}
