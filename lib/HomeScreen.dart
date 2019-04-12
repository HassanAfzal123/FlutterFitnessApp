import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class userHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserHomeScreenState();
  }
}


class _UserHomeScreenState extends State<userHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){

    final logo_img = new CircleAvatar(
      radius: 80.0,
      backgroundColor: Colors.black,
      child:Container(
        decoration: BoxDecoration(color: Colors.transparent,
          image: new DecorationImage(image:
          new AssetImage(
              "assets/logo.png"
          ),
          ),
        ),
      ),
    );

    final myDrawer = new  SizedBox( width: MediaQuery.of(context).size.width * 0.60,
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: logo_img,
              decoration: BoxDecoration(
                  color: Colors.redAccent
              ),
            ),
            ListTile(
              title: Center(
                child: Text('Item 1',style: TextStyle(
                color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
              ),
              ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
              },
            ),
            ListTile(
              title: Center(
                child: Text('Item 1',style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                ),
                ),
              ),
              onTap: () {
                // Update the state of the app
                // ...
              },
            )
          ],
        ),
      ),
    );

    return new Scaffold(
        key: _scaffoldKey,
        drawer: myDrawer,
        appBar: new AppBar(
        leading: new IconButton(icon: new Icon(Icons.list),
        onPressed: () => _scaffoldKey.currentState.openDrawer()),
    )

    );
  }

}