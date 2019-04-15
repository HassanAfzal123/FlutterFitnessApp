import 'dart:async';
import 'package:fitness_app_flutter/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Profile.dart';

class TabScreen extends StatefulWidget {
  @override
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
  final List<Widget> _children = [Profile(Colors.green),Profile(Colors.blue)];    // Currently initialized with Profile only, but first one should be home class
  @override


 Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.list),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),

            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile')
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
